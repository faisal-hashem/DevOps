Push-Location c:\TEMP #script saves into MGMTSRV4
Import-Module "C:\Users\fhashem\Documents\WindowsPowershell\Modules\Okta\Okta.psm1" -Global 
"C:\Users\fhashem\Documents\WindowsPowershell\Modules\Okta\okta_org.ps1" #import modules

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

$CurrentDate = Get-Date -Format MMddyy
$YesterdayDate = "{0:MMddyy}" -f (get-date).AddDays(-1)

$NewData = "GENATLADM$CurrentDate.CSV"
$YesterdayData = "GENATLADM$YesterdayDate.CSV"

$header = "employeeID", "password", "firstName", "middleName", "lastName", "email", "jobFamily", "department", "hireDate", "title", "location", "managerID", "managerName", "managerEmail", "workerType", "JobTitle", "language"
$wdu = oktaGetUsersbyAppID -aid 0oa3lyx1cksaxP9jP0x7

$LRNUsers = $wdu.profile | Where-Object { $_.Workday_ID -ne $null } | Select-Object #whoever that has a workdayID the select-object array will run
@{Name = "employeeID"; Expression = { ($_.workday_ID) } }, #ID changes after it converts 
@{Name = "password"; Expression = { "" } }, #how does this connect to the secure string
@{Name = "firstName"; Expression = { ($_.firstName) } }, `
@{Name = "middleName"; Expression = { ($_.middleName) } }, `
@{Name = "lastName"; Expression = { ($_.lastName) } }, `
@{Name = "email"; Expression = { ($_.email) } }, `
@{Name = "jobFamily"; Expression = { ($_.CostCenterName) } }, `
@{Name = "department"; Expression = { ($_.supervisoryOrg) } }, `
@{Name = "hireDate"; Expression = { ("{0:MM/dd/yyyy}" -f [datetime]$_.Hire_Date) } }, #look into
@{Name = "title"; Expression = { ($_.businessTitle) } }, `
@{Name = "location"; Expression = { ($_.location) } }, `
@{Name = "managerID"; Expression = { ($_.managerId) } }, `
@{Name = "managerName"; Expression = { ($_.managerUserName) } }, `
@{Name = "managerEmail"; Expression = { ($_.managerUserName) + '@generalatlantic.com' } }, `
@{Name = "workerType"; Expression = { ($_.accountType) } }, `
@{Name = "jobTitle"; Expression = { $_.job_title } }, `
@{Name = "language"; Expression = { "" } }

if (-Not (Test-Path .\$YesterdayData)) { throw "Yesterday's Data is missing" }

Else {

    $OldData = Import-Csv .\$YesterdayData -Header $header
    $LRNUsers | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | Set-Content $NewData -Encoding UTF8
    $NewestData = Import-Csv .\$NewData -Header $header

    $compare = Compare-Object $YesterdayData $NewestData -Property employeeid
    $compare.sideindicator |
}


$LRNUsers | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | Set-Content $NewData -Encoding UTF8







#Now we will format the password in the csv file to secure it 
If (-Not (Test-Path .\LRN.TXT)) { throw "The credential file is missing" } #how does this LRN.TXT file get created and to what directory?
$username = (Get-Content .\LRN.TXT)[0] #Line 0 is username
$encPassword = (Get-Content .\LRN.TXT)[1] | ConvertTo-SecureString  #Line 1 is password
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($encPassword))

If (-Not (Test-Path .\PSCP.exe)) { throw "The PSCP.exe file is missing" } #how does this PSCP.exe get created and to what diretory?
$hostkey = "8d:ed:07:d4:46:a2:30:fb:f3:c8:22:16:7e:c7:24:cb" #where are we getting this from
$result = .\PSCP.exe =sftp -batch -l $username -pw $password $NewData sftpbulkload.lrn.com:$NewData
$result | Set-Content Output.txt

If ($result -match "100%") { Move-Item $NewData .\Uploaded }

#send email the upload has failed
Else {
    $mailMessage = @{
        From       = "Your-Email"
        To         = "Your-Email, "
        SmtpServer = "smtp-address"
        Subject    = "$Data1 upload to LRN failed"
        Body       = "The upload of the LRN demographic file has failed. the process runs as a scheduled task on $env:COMPUTERNAME. Please investigate"
    }
    Send-MailMessage @mailMessage
}
