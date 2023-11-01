#Search-AzGraph -Query "Patchassessmentresources | where type =~ "microsoft.compute/virtualmachines/patchAssessmentResults/softwarePatches" | project properties.patchName"

Search-AzGraph -Query "PatchAssessmentResources | project properties.patchName"