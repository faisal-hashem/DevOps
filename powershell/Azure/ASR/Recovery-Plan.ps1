param(
    $name,                   # needs to be passed in, probably as some combo of usename 
    $vaultName,              # should be passed in as data.terraform_remote_state.VAULT.outputs.asr_vault_name
    $containerName          # should be passed in as module.containermodule.asr_container_primary_name
)

# Other vars to load from Build Agent
$subscription = $env:ARM_SUBSCRIPTION_ID
$terraformAppId = $env:ARM_CLIENT_ID
$terraformAppSecret = $env:ARM_CLIENT_SECRET
$tenant = $env:TF_VAR_tenant_id

# Build Creds to connect to Azure using Service Principal
$appCreds = New-Object System.Management.Automation.PSCredential $terraformAppId,$($terraformAppSecret | convertto-securestring -asplaintext -force)

# Import Az Module and connect to Azure
Import-Module Az | Out-Null   
Connect-AzAccount -ServicePrincipal -Subscription $subscription -Tenant $tenant -Credential $appCreds 3>nul | Out-Null

# Set subscription context
Set-AzContext -SubscriptionId $subscription | Out-Null

# Get vault and set vault context for subsequent ASR commands
$vault = Get-AzRecoveryServicesVault -Name $vaultName
Set-AZRecoveryServicesAsrVaultContext -Vault $vault | Out-Null

# Get Fabrics
$fabrics = Get-AZRecoveryServicesASRFabric

# Retrieve the Primary Fabric Object
$primaryFabric = $fabrics | where {$_.Name -like "*primary*"}

# Retrieve the Secondary Fabric Object
$secondaryFabric = $fabrics | where {$_.Name -like "*secondary*"}

# Get the container object 
$container = Get-ASRProtectionContainer -FriendlyName $containerName -Fabric $primaryFabric

# Get Protected Items in container to add to Recovery Plan
$rpi = Get-ASRReplicationProtectedItem -ProtectionContainer $container

# Check if plan exists
$exists = Get-AzRecoveryServicesAsrRecoveryPlan -Name $name -ErrorAction SilentlyContinue

If (-Not $Exists){

    # Create the Plan and add all items from the container to it
    New-AzRecoveryServicesAsrRecoveryPlan -Name $name -PrimaryFabric $primaryFabric -RecoveryFabric $secondaryFabric -ReplicationProtectedItem $rpi | Out-null

    # Validate the created plan
    $createdPlan = Get-AzRecoveryServicesAsrRecoveryPlan -Name $name -ErrorAction SilentlyContinue

    If (-not ($createdPlan)){ # In case there is a timing issue with validating the plan, this will check every 2 seconds for one minute before it fails
        $count = 0
        do {
            Start-Sleep -Seconds 2
            $count++
            $createdPlan = Get-AzRecoveryServicesAsrRecoveryPlan -Name $name -ErrorAction SilentlyContinue
        } until (($createdPlan -ne $null) -or ($count -eq 30))
    }
    $planAction = "Recovery plan created" 
    $updateJob = $null
}

If ($exists){
    # Establish existing plan as createdPlan
    $createdPlan = $exists
    $currProtectedItems = $createdPlan.groups | where {$_.groupType -eq "Boot"} | select -ExpandProperty ReplicationProtectedItems
    $planAction = "No action required"
    
    If ($rpi.count -ne $currProtectedItems.count){
        # Do we have to find difference between the two or just overwrite the plan with new protected items?  Hopefully just overwrite?
        If ($rpi.count -gt $currProtectedItems.count){
            $rpitoAdd = Compare-Object $rpi $currProtectedItems -Property Name -PassThru | where {$_.sideIndicator -eq "<="}
            $group = $CreatedPlan.Groups | where {$_.groupType -eq "Boot"}
            $createdPlan = Edit-AzRecoveryServicesAsrRecoveryPlan -RecoveryPlan $createdPlan -AddProtectedItem $rpitoAdd -Group $group
            $updateJob = Update-AzRecoveryServicesAsrRecoveryPlan -RecoveryPlan $createdPlan
            $planAction = "Adding new protected item to plan"
        } # End If Loop to Add Items
        If ($rpi.count -lt $currProtectedItems.count){
            $rpitoRemove = Compare-Object $rpi $currProtectedItems -Property Name -PassThru | where {$_.sideIndicator -eq "=>"}
            $group = $CreatedPlan.Groups | where {$_.groupType -eq "Boot"}
            $createdPlan = Edit-AzRecoveryServicesAsrRecoveryPlan -RecoveryPlan $createdPlan -RemoveProtectedItem $rpitoRemove -Group $group
            $updateJob = Update-AzRecoveryServicesAsrRecoveryPlan -RecoveryPlan $createdPlan
            $planAction = "Removing protected item from plan"
        } # End If Loop to Remove Items
    } # If loop for non-equal container/plan RPI

}

$result = New-Object psobject -Property @{
    planName = $name
    vault = $vault.Name
    subscription = ((get-azcontext).name).split()[0]
    #protectedItems = ((Get-AzRecoveryServicesAsrRecoveryPlan -Name $name).groups | where {$_.groupType -eq "Boot"} | select -ExpandProperty ReplicationProtectedItems | select -expand FriendlyName) -join ", "  
    protectedItems = ($createdPlan.groups | where {$_.groupType -eq "Boot"} | select -ExpandProperty ReplicationProtectedItems | select -expand FriendlyName) -join ", " 
    protectedCount = ($createdPlan.Groups | where {$_.groupType -eq "Boot"} | select -ExpandProperty ReplicationProtectedItems).count
    planAction = $planAction
    #updateJob = $updateJob
}

$outResult = $result | ConvertTo-Json
Write-Output $outResult