﻿$NewData = "c:\temp\ClientSecretsExpirationDate.CSV"

#secret expiration date filter (for example 30 days)
$LimitExpirationDays = 30

#Retrieving the list of secrets that expires in the above range of days
$SecretsToExpire = Get-AzureADApplication -All:$true | ForEach-Object {
    $app = $_
    @(
        Get-AzureADApplicationPasswordCredential -ObjectId $_.ObjectId
        Get-AzureADApplicationKeyCredential -ObjectId $_.ObjectId
    ) | Where-Object {
        $_.EndDate -lt (Get-Date).AddDays($LimitExpirationDays)
    } | ForEach-Object {
        $id = "Not set"
        if($_.CustomKeyIdentifier) {
            $id = [System.Text.Encoding]::UTF8.GetString($_.CustomKeyIdentifier)
        }
        [PSCustomObject] @{
            App = $app.DisplayName
            ObjectID = $app.ObjectId
            AppId = $app.AppId
            EndDate = $_.EndDate
        }
    }
}


$SecretsToExpire | Sort-Object EndDate | Select-Object App, EndDate  #ConvertTo-Csv -NoTypeInformation | Set-Content $NewData -Encoding UTF8 

#Printing the list of secrets that are near to expire
if($SecretsToExpire.Count -EQ 0) {
    Write-Output "No secrets found that will expire in this range"
}
else {
    Write-Output "Secrets that will expire in this range:"
    Write-Output $SecretsToExpire.Count
    Write-Output $SecretsToExpire
}
