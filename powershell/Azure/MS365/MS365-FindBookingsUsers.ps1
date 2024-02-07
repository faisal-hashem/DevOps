# First, get all of the users who are "IT people"
$aou = oktaListActiveUsers
$ITPeople = $aou.Profile | where { $_.wd_department_id -eq "Information Technology" }

# Determine if the users from the list are licensed to see if we need to do anything
# First get all of the status on all of the users from the previous step
$UserLicenseStatus = Foreach ($person in $ITPeople) {
    Get-MSolUser -userPrincipalName $person.email
}

# Get all IT people who are licensed
$LicensedIT = $userLicenseStatus | where { $_.isLicensed -eq $True }
# For the more efficient way we could have done it, look at the bottom for the next step.


# Check through each of the licensed users to see if they currently have MICROSOFTBOOKINGS disabled.  If so, export them to a file
# I did this just to make sure I was only looping through people who needed the change
$PeopleWithoutBookingsPath = C:\temp\PeopleWithoutBookings.txt
Foreach ($user in $licensedIT) {
    $currDisabled = $user.Licenses | where { $_.AccountSKUID -eq "DOMAIN:SPE_E3" } | select -ExpandProperty ServiceStatus | where { $_.ProvisioningStatus -eq "Disabled" } | select -ExpandProperty ServicePlan | select -ExpandProperty ServiceName
    If ($currDisabled -contains "MICROSOFTBOOKINGS") {
        $user.UserPrincipalName | Out-File $PeopleWithoutBookingsPath -Append  # This will export only the UserPrincipalName of the person to a .txt file for use with licensing
    }
}

# Now that we have the list of people who don't have Bookings, we want to work on re-establishing their License Options
$peopleToFix = Get-Content $PeopleWithoutBookingsPath # This imports the list of users exported from the previous loop
foreach ($account in $peopleToFix) {    
    $msolUser = Get-MsolUser -UserPrincipalName $account 
    $currDisabled = $msolUser.Licenses | where { $_.AccountSkuID -eq "DOMAIN:SPE_E3" } | select -ExpandProperty ServiceStatus | where { $_.ProvisioningStatus -eq "Disabled" } | select -ExpandProperty ServicePlan | select -ExpandProperty ServiceName
    $newDisabled = $currDisabled | where { $_ -ne "MICROSOFTBOOKINGS" }

    # The below stuff isn't ideal, I just used it to put in some guard rails and to watch what was happening
    $licObj = New-MsolLicenseOptions -AccountSkuId "DOMAIN:SPE_E3" -disabledplans $newDisabled
    Write-Output "Modifying $user"
    Write-Output "Current count: $($currDisabled.Count)"
    Write-Output $($currDisabled | sort)
    Write-Output "----"
    Write-Output "New count: $($newDisabled.Count)"
    Write-Output $($newDisabled | sort)
    Pause # This gave me an opportunity to CONTROL+C if something wasn't right before it actually did something

    Set-MSOLUserLicense -UserPrincipalName $account -licenseoptions $licObj
}


# We could have done it this way to be more efficient, I just liked paring it down and monitoring it

Foreach ($user in $licensedIT) {
    $currDisabled = $user.Licenses | where { $_.AccountSKUID -eq "DOMAIN:SPE_E3" } | select -ExpandProperty ServiceStatus | where { $_.ProvisioningStatus -eq "Disabled" } | select -ExpandProperty ServicePlan | select -ExpandProperty ServiceName
    If ($currDisabled -contains "MICROSOFTBOOKINGS") {
        $newDisabled = $currDisabled | where { $_ -ne "MICROSOFTBOOKINGS" }
        $licObj = New-MsolLicenseOptions -AccountSkuId "DOMAIN:SPE_E3" -disabledplans $newDisabled
        Set-MSOLUserLicense -UserPrincipalName $user.UserPrincipalName -licenseoptions $licObj
        
    }
}