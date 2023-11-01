$patchlist = Search-AzGraph -Query "PatchAssessmentResources | project properties.patchName | where properties_patchName !contains 'KB'"



$RGName = "asrtstdevuc1" 
$config1Name = "testconfig"
$config2Name = "testconfig2"
$scope = "InGuestPatch" 
$location = "centralus"
$timeZone = "Eastern Standard Time" 
$duration = "3:00"
$startDateTime = "2023-03-18 09:00"
$recurEvery = "Week Saturday, Sunday"
$WindowsParameterClassificationToInclude = "FeaturePack","ServicePack";
$RebootOption = "IfRequired";
$LinuxParameterClassificationToInclude = "Other";
$LinuxParameterPackageNameMaskToInclude = "apt","httpd";

New-AzMaintenanceConfiguration -ResourceGroupName $RGName -Name $config1Name -MaintenanceScope $scope -Location $location `
-StartDateTime $startDateTime -Timezone $timeZone -Duration $duration -RecurEvery $recurEvery `
-WindowParameterClassificationToInclude $WindowsParameterClassificationToInclude `
-InstallPatchRebootSetting $RebootOption -LinuxParameterPackageNameMaskToInclude $LinuxParameterPackageNameMaskToInclude `
-LinuxParameterClassificationToInclude $LinuxParameterClassificationToInclude `
-ExtensionProperty @{"InGuestPatchMode"="User"}

New-AzMaintenanceConfiguration -ResourceGroupName $RGName -Name $config2Name -MaintenanceScope $scope -Location $location `
-StartDateTime $startDateTime -Timezone $timeZone -Duration $duration -RecurEvery $recurEvery `
-WindowParameterClassificationToInclude $WindowsParameterClassificationToInclude `
-InstallPatchRebootSetting $RebootOption -LinuxParameterPackageNameMaskToInclude $LinuxParameterPackageNameMaskToInclude `
-LinuxParameterClassificationToInclude $LinuxParameterClassificationToInclude `
-ExtensionProperty @{"InGuestPatchMode"="User"}