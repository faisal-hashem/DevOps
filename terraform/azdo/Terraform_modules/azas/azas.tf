resource "azurerm_app_service" "thisappservice" {
  name                = "${var.use_name}${var.env}${var.app_name}"
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = var.asp_id
  client_affinity_enabled = true
  site_config {
    scm_type                 = "None"
    dotnet_framework_version = var.dotnet_version
  }
  app_settings = var.app_settings
  provisioner "local-exec" {
    command = "pwsh ./scripts/oktatrust.ps1 https://${azurerm_app_service.thisappservice.name}.${var.ase_name}.appserviceenvironment.net ${azurerm_app_service.thisappservice.name}"
    on_failure = continue
  }
  lifecycle {
    ignore_changes = [site_config.0.scm_type]
  }
}
resource "azurerm_role_assignment" "fame_role" {
  scope                = azurerm_app_service.thisappservice.id
  role_definition_name = var.azure_role
  principal_id         = var.aad_principal_id
}
