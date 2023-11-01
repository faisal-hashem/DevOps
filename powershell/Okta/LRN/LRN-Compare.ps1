Push-Location c:\temp #script saves into MGMTSRV4
Import-Module "C:\Users\fhashem\Documents\WindowsPowershell\Modules\Okta\Okta.psm1" -Global 
"C:\Users\fhashem\Documents\WindowsPowershell\Modules\Okta\okta_org.ps1" #import modules

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

$header = "employeeID", "password", "firstName", "middleName", "lastName", "email", "jobFamily", "department", "hireDate", "title", "location", "managerID", "managerName", "managerEmail", "workerType", "jobtitle", "language"

$CurrentDate = Get-Date -Format MMddyy
$YesterdayDate = "{0:MMddyy}" -f (get-date).AddDays(-1)

$NewData = ".\GENATLADM$CurrentDate.CSV"
$YesterdaysDatafile = ".\GENATLADM$YesterdayDate.CSV"

$aou = oktaListActiveUsers # Get all Okta users
$LRNUsers = oktaGetUsersbyAppID -aid 0oaiqu877u7rYj2iT0x7		# Get all users assigned to LRNUsers
$FilteredAOU = $aou | Where-Object { $_.id -in ($LRNUsers.id) }	# Filter All Okta users to just LRNUsers

$CoreLRNUsers = $FilteredAOU.profile | Where-Object { $_.WorkdayID -ne $null } | Select-Object @{Name = "employeeID"; Expression = { ($_.WorkdayID) } }, `
@{Name = "password"; Expression = { "" } }, `
@{Name = "firstName"; Expression = { ($_.firstName) } }, `
@{Name = "middleName"; Expression = { ($_.middleName) } }, `
@{Name = "lastName"; Expression = { ($_.lastName) } }, `
@{Name = "email"; Expression = { ($_.email) } }, `
@{Name = "jobFamily"; Expression = { ($_.CostCenter) } }, `
@{Name = "department"; Expression = { ($_.wd_Supervisory_Organization) } }, `
@{Name = "hireDate"; Expression = { ("{0:MM/dd/yyyy}" -f [datetime]$_.HireDate) } }, `
@{Name = "title"; Expression = { ($_.Title) } }, `
@{Name = "location"; Expression = { ($_.locationCustomAttribute) } }, `
@{Name = "managerID"; Expression = { ($_.managerId) } }, `
@{Name = "managerName"; Expression = { ($_.manager) } }, `
@{Name = "managerEmail"; Expression = { ($_.manager) + '@generalatlantic.com' } }, `
@{Name = "workerType"; Expression = { ($_.workerType) } }, `
@{Name = "jobTitle"; Expression = { $_.wd_Job_Title } }, `
@{Name = "language"; Expression = { "" } }

$CoreLRNUsers | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | Set-Content $NewData -Encoding UTF8 

$CurrentData = import-csv $NewData -Header $header

if (-Not (Test-Path .\$YesterdayDataFile)) { throw "Yesterday's Data is missing" }
$YesterdaysData = import-csv ".\GENATLADM$YesterdayDate.CSV" -Header $header | where { $_.language -ne "Deactivated" } | Select Employeeid, password, firstname, middlename, lastname, email, jobfamily, department, hiredate, title, location, managerID, managerName, managerEmail, workertype
$Compareddata = Compare-Object $YesterdaysData $CurrentData -Property employeeid -PassThru -IncludeEqual | 
Select-Object *, 
@{
    n = "Status";
    e = { if ($_.Sideindicator -eq "<=") { Write-Output "Deactivated" }
        if ($_.Sideindicator -eq "=>") { Write-Output "Activated" }
        if ($_.Sideindicator -eq "==") { Write-Output "Active" }
    }
}

$LRNUsers = $Compareddata | Select-Object -Property Employeeid, password, firstname, middlename, lastname, email, jobfamily, department, hiredate, title, location, managerID, managerName, managerEmail, workertype, language, status

$LRNUsers | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | Set-Content $NewData -Encoding UTF8


If (-Not (Test-Path .\LRN.TXT)) { throw "The credential file is missing" } #how does this LRN.TXT file get created and to what directory?
$username = (Get-Content .\LRN.TXT)[0] #Line 0 is username
$encPassword = (Get-Content .\LRN.TXT)[1] | ConvertTo-SecureString  #Line 1 is password
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($encPassword))

If (-Not (Test-Path .\PSCP.exe)) { throw "The PSCP.exe file is missing" } #how does this PSCP.exe get created and to what diretory?
$hostkey = "8d:ed:07:d4:46:a2:30:fb:f3:c8:22:16:7e:c7:24:cb" #where are we getting this from
$result = .\PSCP.exe =sftp -batch -l $username -pw $password $ExportFile sftpbulkload.lrn.com:$ExportFile
$result | Set-Content Output.txt

If ($result -match "100%") { Move-Item $ExportFile .\Uploaded }

#send email the upload has failed
Else {
    $mailMessage = @{
        From       = "your-email"
        To         = "your-email, "
        SmtpServer = "smtp-server-address"
        Subject    = "$ExportFile upload to LRN failed"
        Body       = "The upload of the LRN demographic file has failed. the process runs as a scheduled task on $env:COMPUTERNAME. Please investigate"
    }
    Send-MailMessage @mailMessage
} 