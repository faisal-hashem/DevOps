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

    #VNET Selection
    Write-Host " "
    Write-Host -ForegroundColor White -BackgroundColor Black "--------------------Azure VNETs------------------------------"
    Write-Host " "

    #Retrieve all VNETs with ASR in the name
    if ($ASRVault.Location -eq 'centralus') {
        $script:VirtualNetworks = Get-AzVirtualNetwork | where {$_.Location -match 'centralus'}
    }
    else {
        $script:VirtualNetworks = Get-AzVirtualNetwork | where {$_.Location -match 'eastus2'}
    }
    
    #$VirtualNetworks = Get-AzVirtualNetwork #-Name "*asr*"

    $VNetCounter = 1
    foreach ($Network in $VirtualNetworks) {
        Write-Output "($VNetCounter) $($Network.name)"
        $VNetCounter++;
        Write-Output ""
    }

    $script:VNETNumber = Read-Host 'Please choose a VNET. Must be the Secondary Region VNET'
    $script:VNET = $VirtualNetworks[$VNETNumber - 1]
    $script:VNETName = $VirtualNetworks[$VNETNumber -1].Name

    $script:ASRVNETObject = Get-AzVirtualNetwork -Name $VNETName

    #Use this in Test Failover function
    $script:ASRVNET = $ASRVNETObject.id #VNET - USE THIS

}

function ASRTestFailover {
    
    #Starts MAIN Test Failover job. Inputting Recovery Plan & Secondary Region VNET
    $TFOJob = Start-AZRecoveryServicesAsrTestFailoverJob -RecoveryPlan $ASRRecoveryPlan -Direction PrimaryToRecovery -AzureVMNetworkId $ASRVNET -Verbose

    #do/while is being used to make sure Test Failover State is provided as long as State is in Progress OR Not-Started
    do {
        $TFState = Get-AzRecoveryServicesAsrJob -Job $TFOJob | Select-Object State
        
        Clear-Host
        Write-Host -ForegroundColor White -BackgroundColor Black "----------------Monitoring-Test-Failover-----------------"
        Write-Host -ForegroundColor White -BackgroundColor Black "----------Status will refresh every 5 seconds------------"

        #try/catch being used to check for any Errors
        try {
        
        }

        catch {
            Write-Host " "
            Write-Host -ForegroundColor Red -BackgroundColor Black "ERROR -Unable to get status of Test Failover Job"
            Write-host -ForegroundColor Red -BackgroundColor Black "ERROR - " $_
                log "Error" "Unable to get status of Test Failover Job"
                log "Error" $_

            Write-Host " " 
            exit
        }

        Write-Host "Failover status for $($TFOJob.TargetObjectName) is $($TFState.state)"
        Start-Sleep 5;
    }
    while (($TFState.state -eq "InProgress") -or ($TFState.state -eq "NotStarted"))

    #if/else wll exit code if Test Failover state is in Failed state. If it is not in failed state it will continue to Clean Up Test Failover items created. 
    if ($TFState.state -eq "Failed") {

        Write-Host("The Test Failover Job has failed. Scipt will Terminate now")
        exit
    }

    else {
        Read-Host -Prompt "Test failover has completed successfully. Please check ASR Portal and test the VMs. Once done, please press ENTER here to continue the Script to Clean-Up"

        #Starting to Clean Up all resources created by Test Failover job.
        $TFOJobCleanUp = Start-AzRecoveryServicesAsrTestFailoverCleanupJob -RecoveryPlan $ASRRecoveryPlan -Comment "Testing Completed" -Verbose

        #do/while is being used to provide Status of the Clean Up job. Will check status until its no longer In-Progress OR Not-Started
        do {
            $TFOCleanUpState = Get-AzRecoveryServicesAsrJob -Job $TFOJobCleanUp | Select-Object State

            Clear-Host
            Write-Host -ForegroundColor White -BackgroundColor Black "-------------------Monitoring-Cleanup--------------------"
            Write-Host -ForegroundColor White -BackgroundColor Black "----------Status will refresh every 5 seconds------------"

            #try/catch is once again being used to catch any Errors during the Clean-Up process
            try { 

            }

            catch {
                Write-Host " "
                Write-Host -ForegroundColor Red -BackgroundColor Black "ERROR -Unable to get status of Test Failover Job"
                Write-host -ForegroundColor Red -BackgroundColor Black "ERROR - " + $_
                    log "Error" "Unable to get status of Test Failover Job"
                    log "Error" $_

                Write-Host " " 
                exit
            }

            Write-Host "Cleanup Status for $($TFOJob.TargetObjectName) is $($TFOCleanUpState.state)"
            Start-Sleep 5;
        }
        while (($TFOCleanUpState.state -eq "InProgress") -or ($TFOCleanUpState.state -eq "NotStarted"))


        Write-Host "Test Failover Cleanup Completed"
    }
}       



AZModule
Subscription
ASRRecovery
ASRTestFailover