function AZModule {

    #Checks for AZ Module is installed. If not, will need to install it. Imports Az Modules.
    $azExists = Get-InstalledModule Az -AllVersions -ErrorAction SilentlyContinue

    if ($azExists) {
        Write-Host "Az PowerShell installed ..."
    }
    else {
        Write-Host "You need Az PowerShell https://docs.microsoft.com/en-us/powershell/azure/"
        Break
    }

    Import-Module Az
    Clear-Host

}

function Subscription {

    $DisabledContext = Disable-AzContextAutosave -Scope Process
    Clear-AzContext
    # Clear-AzContext -Scope CurrentUser -Force

    #Connect to Azure and get all subscriptions
    $AZConnect = Connect-AzAccount

    Write-Host " "
    Write-Host -ForegroundColor White -BackgroundColor Black "--------------------Azure Subscriptions----------------------"
    Write-Host " "
    $azureSubscriptions = Get-AzSubscription

    #Setting counter to 1 to utilize for index and subscription selection
    $azureSubscriptionCounter = 1

    #Displaying Subscription selection for the user
    foreach ($azureSubscription in $azureSubscriptions) {
        Write-Output "($azureSubscriptionCounter) $($azureSubscription.Name)"
        $azureSubscriptionCounter++;
        Write-Output ""
    }

    $subscriptionNumber = Read-Host 'Please choose subscription'
    
    #Subtracting 1 since numbering starts from 0. Preventing users to select 0. 
    $script:subscription = Select-AzSubscription -SubscriptionId $azureSubscriptions[$subscriptionNumber - 1].Id
    $script:subscriptionNamePull = Select-AzSubscription -SubscriptionName $azureSubscriptions[$subscriptionNumber - 1].Name
    $script:subscriptionName = $subscriptionNamePull.Subscription.Name
    $script:subscriptionid = $subscription.Subscription.Id

}

function ASRRecovery {
    
    #ASR Vault Selection
    Write-Host " "
    Write-Host -ForegroundColor White -BackgroundColor Black "-------------------ASR-Recovery-Vaults-----------------------"
    Write-Host " "

    #Retrieve All ASR Vaults in Subscription
    $RecoveryVaults = Get-AzRecoveryServicesVault

    $RecoveryVaultCounter = 1
    foreach ($RecoveryVault in $RecoveryVaults) {
        Write-Output "($RecoveryVaultCounter) $($RecoveryVault.Name)"
        $RecoveryVaultCounter++;
        Write-Output ""
    }

    $script:RecoveryVaultNumber = Read-Host 'Please choose Recovery Vault'
    $script:ASRVault = $RecoveryVaults[$RecoveryVaultNumber - 1]
    $script:ASRVaultName = $RecoveryVaults[$RecoveryVaultNumber - 1].Name

    #Set ASR Vault Context
    Set-AzRecoveryServicesAsrVaultContext -Vault $script:ASRVault | Out-Null

    #Set ASR Fabrics
    if ($ASRVaultName -match 'uc1-to-ue2') {
        
        $script:PrimaryFabric = Get-AzRecoveryServicesAsrFabric -Name "asr-fabric-primary-uc1-to-ue2-$subscriptionName"
        $script:RecoveryFabric = Get-AzRecoveryServicesAsrFabric -Name "asr-fabric-secondary-uc1-to-ue2-$subscriptionName"
    
    }

    elseif ($ASRVaultName -match 'ue2-to-uc1') {
        
        $script:PrimaryFabric = Get-AzRecoveryServicesAsrFabric -Name "asr-fabric-primary-ue2-to-uc1-$subscriptionName"
        $script:RecoveryFabric = Get-AzRecoveryServicesAsrFabric -Name "asr-fabric-secondary-ue2-to-uc1-$subscriptionName"
    }

    #ASR Container Selection
    Write-Host " "
    Write-Host -ForegroundColor White -BackgroundColor Black "-------------------ASR-Containers-----------------------"
    Write-Host " "

    #Retrieve Primary ASR Containers
    $PrimaryContainers = Get-AzRecoveryServicesAsrProtectionContainer -fabric $PrimaryFabric

    $PrimaryContainerCounter = 1
    foreach ($PrimaryContainer in $PrimaryContainers) {
        Write-Output "($PrimaryContainerCounter) $($PrimaryContainer.Name)"
        $PrimaryContainerCounter++;
        Write-Output ""
    }

    #Set Primary Container Name & Object & Container Mapping
    $script:PrimaryContainerNumber = Read-Host 'Please choose the Container for the Azure VM you want to failover'
    $script:PrimContainer = $PrimaryContainers[$PrimaryContainerNumber - 1]
    $script:PrimaryContainerName = $PrimaryContainers[$PrimaryContainerNumber - 1].Name

    if ($PrimContainer.FabricFriendlyName -eq 'Central US') {
        $script:PrimaryContainerMapping = $PrimContainer | select -ExpandProperty ProtectionContainerMappings | where { $_.SourceFabricFriendlyName -match "Central US" }
    }
    else {
        $script:PrimaryContainerMapping = $PrimContainer | select -ExpandProperty ProtectionContainerMappings | where { $_.SourceFabricFriendlyName -match "East US 2" }
    }

    #Set Recovery Container Name & Object & Container Mapping
    $script:RecoveryContainerName = $PrimaryContainerName.Replace('primary', 'secondary')
    $script:RecContainer = Get-AzRecoveryServicesAsrProtectionContainer -fabric $RecoveryFabric -Name $RecoveryContainerName

    if ($RecContainer.FabricFriendlyName -eq 'Central US') {
        $script:RecoveryContainerMapping = $RecContainer | select -ExpandProperty ProtectionContainerMappings | where { $_.SourceFabricFriendlyName -match "Central US" }
    }
    else {
        $script:RecoveryContainerMapping = $RecContainer | select -ExpandProperty ProtectionContainerMappings | where { $_.SourceFabricFriendlyName -match "East US 2" }
    }

    #Retrieve VMs from ASR Containers
    $script:PrimaryRPI = Get-AzRecoveryServicesAsrReplicationProtectedItem -ProtectionContainer $PrimContainer
    $script:RecoveryRPI = Get-AzRecoveryServicesAsrReplicationProtectedItem -ProtectionContainer $RecContainer

    #Storage Account Selection
    Write-Host " "
    Write-Host -ForegroundColor White -BackgroundColor Black "-------------------ASR Cache Storage Accounts-----------------------"
    Write-Host " "

    #Retrieve All ASR Cache Storage Accounts in Subscription
    if ($PrimaryContainerMapping.SourceFabricFriendlyName -eq "Central US") {
        $script:PrimaryStorageAccounts = Get-AzStorageAccount | where { $_.StorageAccountName -match 'uc1toue2' }
    }
    else {

        $script:PrimaryStorageAccounts = Get-AzStorageAccount | where { $_.StorageAccountName -match 'ue2touc1' }
    }

    $PrimaryStorageAccountCounter = 1
    foreach ($PrimaryStorageAccount in $PrimaryStorageAccounts) {
        Write-Output "($PrimaryStorageAccountCounter) $($PrimaryStorageAccount.StorageAccountName)"
        $PrimaryStorageAccountCounter++;
        Write-Output ""
    }

    $script:PrimaryStorageAccountNumber = Read-Host 'Please choose the Cache Storage Account for the Failover(Primary Region -> Secondary Region)'
    $script:PrimaryCacheStorageAccount = $PrimaryStorageAccounts[$PrimaryStorageAccountNumber - 1]
    $script:PrimaryCacheStorageAccountName = $PrimaryStorageAccounts[$PrimaryStorageAccountNumber - 1].StorageAccountName

    #Set Recovery Cache Storage Account (needed for Failback)
    if ($PrimaryContainerMapping.SourceFabricFriendlyName -eq "Central US") {

        $script:RecoveryCacheStorageAccountName = $PrimaryCacheStorageAccountName.Replace('uc1toue2', 'ue2touc1')
        $script:RecoveryCacheStorageAccount = Get-AzStorageAccount | where { $_.StorageAccountName -eq $RecoveryCacheStorageAccountName }
    }
    else {

        $script:RecoveryCacheStorageAccountName = $PrimaryCacheStorageAccountName.Replace('ue2touc1', 'uc1toue2')
        $script:RecoveryCacheStorageAccount = Get-AzStorageAccount | where { $_.StorageAccountName -eq $RecoveryCacheStorageAccountName }    
    }

    #Set Resource Groups for Source/Recovery VMs
    $script:PrimaryResourceGroupName = $PrimaryCacheStorageAccount.ResourceGroupName
    $script:PrimaryResourceGroup = Get-AzResourceGroup -Name $PrimaryResourceGroupName
    $script:RecoveryResourceGroupName = $RecoveryCacheStorageAccount.ResourceGroupName
    $script:RecoveryResourceGroup = Get-AzResourceGroup -Name $RecoveryResourceGroupName

    #ASR Recovery Plan Selection
    Write-Host " "
    Write-Host -ForegroundColor White -BackgroundColor Black "-------------------ASR-Recovery-Plans------------------------"
    Write-Host " "
    $RecoveryPlans = Get-AzRecoveryServicesAsrRecoveryPlan

    $RecoveryPlanCounter = 1
    foreach ($RecoveryPlan in $RecoveryPlans) {
        Write-Output "($RecoveryPlanCounter) $($RecoveryPlan.Name)"
        $RecoveryPlanCounter++;
        Write-Output ""
    }

    $script:RecoveryPlanNumber = Read-Host 'Please choose Recovery Plan'

    #Use this in Test Failover function
    $script:ASRRecoveryPlan = $RecoveryPlans[$script:RecoveryPlanNumber - 1]

}

function ASRFailback {
    
    #Starts MAIN Failback job. Inputting Recovery Plan & Secondary Region VNET
    $FBJob = Start-AzRecoveryServicesAsrUnplannedFailoverJob -RecoveryPlan $ASRRecoveryPlan -Direction RecoveryToPrimary -Verbose

    Write-Host -ForegroundColor White -BackgroundColor Black "----------------Monitoring-Failback-----------------"
    Write-Host -ForegroundColor White -BackgroundColor Black "----------Status will refresh every 5 seconds------------"

    #do/while is being used to make sure Failback State is provided as long as State is in Progress OR Not-Started
    do {
        $FailbackState = Get-AzRecoveryServicesAsrJob -Job $FBJob | Select-Object State
        
        Write-Host -ForegroundColor White -BackgroundColor Green "In-Progress"

        #try/catch being used to check for any Errors
        try {
        
        }

        catch {
            Write-Host " "
            Write-Host -ForegroundColor Red -BackgroundColor Black "ERROR -Unable to get status of Failback Job"
            Write-host -ForegroundColor Red -BackgroundColor Black "ERROR - " $_
            log "Error" "Unable to get status of Failback Job"
            log "Error" $_

            Write-Host " " 
            exit
        }

        Write-Host "Failback status for $($FBJob.TargetObjectName) is $($FailbackState.state)"
        Start-Sleep 5;
    }
    while (($FailbackState.state -eq "InProgress") -or ($FailbackState.state -eq "NotStarted"))

    #if/else wll exit code if Failback state is in Failed state. If it is not in failed state it will continue to Clean Up Failback items created. 
    if ($FailbackState.state -eq "Failed") {

        Write-Host("The Failback Job has failed. Scipt will Terminate now")
        exit
    }

    else {
        Read-Host -Prompt "Failback has completed successfully. Please check ASR Portal and make sure everything looks OK. Once done, please press ENTER here to continue the Script to Re-Protect failed back VMs"

        #Starting to Clean Up all resources created by Failback job.
        $FBJobReProtect = foreach ($RRPI in $RecoveryRPI) { Update-AzRecoveryServicesAsrProtectionDirection -ReplicationProtectedItem $RRPI -AzureToAzure -ProtectionContainerMapping $PrimaryContainerMapping -LogStorageAccountId $PrimaryCacheStorageAccount.Id -RecoveryResourceGroupId $RecoveryResourceGroup.ResourceId }

        Write-Host -ForegroundColor White -BackgroundColor Black "-------------------Monitoring-Cleanup--------------------"
        Write-Host -ForegroundColor White -BackgroundColor Black "----------Status will refresh every 5 seconds------------"

        #do/while is being used to provide Status of the Clean Up job. Will check status until its no longer In-Progress OR Not-Started
        do {
            $FBCleanUpState = Get-AzRecoveryServicesAsrJob -Job $FBJobReProtect | Select-Object State

            write-host -ForegroundColor White -BackgroundColor Green "In Progress"
         
            #try/catch is once again being used to catch any Errors during the Clean-Up process
            try { 

            }

            catch {
                Write-Host " "
                Write-Host -ForegroundColor Red -BackgroundColor Black "ERROR -Unable to get status of Failback Job"
                Write-host -ForegroundColor Red -BackgroundColor Black "ERROR - " + $_
                log "Error" "Unable to get status of Failback Job"
                log "Error" $_

                Write-Host " " 
                exit
            }

            Write-Host "Cleanup Status for $($FBJob.TargetObjectName) is $($FBCleanUpState.state)"
            Start-Sleep 5;
        }
        while (($FBCleanUpState.state -eq "InProgress") -or ($FBCleanUpState.state -eq "NotStarted"))


        Write-Host "Failback Cleanup Completed"
    }
}


AZModule
Subscription
ASRRecovery
ASRFailback