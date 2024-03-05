# Connect to Azure
Install-Module Az -Force
Connect-AzAccount -Identity 

# Get the current date and the date 30 days from now
$currentDate = Get-Date
$expiryThreshold = $currentDate.AddDays(30)

# Fetch all Azure AD Applications
$appRegistrations = Get-AzADApplication

# Initialize an array to hold expiring secrets info
$expiringSecrets = @()

<#
foreach ($i in $appRegistrations) {
    $i.Id
    $i.DisplayName
    $secret = Get-AzADAppCredential -ObjectId $i.Id
    $secret.EndDateTim
}
#>

foreach ($app in $appRegistrations) {
    # Retrieve secrets for each application
    $secrets = Get-AzADAppCredential -ObjectId $app.Id
    foreach ($secret in $secrets) {
        # Check if the secret is expiring within the next month
        if ($secret.EndDateTime -lt $expiryThreshold -and $secret.EndDateTime -gt $currentDate) {
            $expiringSecrets += @{
                AppName = $app.DisplayName
                SecretEndDate = $secret.EndDateTime
            }
        }
    }
}

# Check if there are any expiring secrets
if ($expiringSecrets.Count -gt 0) {
    Write-Output "The following Azure App Registration secrets are expiring within the next month:"
    foreach ($secret in $expiringSecrets) {
        Write-Output "App Name: $($secret.AppName), Secret End Date: $($secret.SecretEndDate)"
    }
} else {
    Write-Output "No Azure App Registration secrets are expiring within the next month."
}