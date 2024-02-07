# This resource will call a script to create an Azure Recovery Plan
resource "null_resource" "recovery_plan" {
  triggers = {
      name = var.name
      build = "${timestamp()}"
  }
  provisioner "local-exec" {
      command     = "../utility_scripts/powershell/Create-AZAsrRecoveryPlan.ps1 -name ${var.name} -vaultName ${var.vaultname} -containerName ${var.containername}"
      interpreter = ["pwsh", "-Command"]
  }
}