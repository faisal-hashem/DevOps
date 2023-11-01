resource "azurerm_function_app" "thisfunctionapp" {
  name                       = "${var.use_name}${var.env}${var.app_name}"
  location                   = var.location
  resource_group_name        = var.rg_name
  app_service_plan_id        = var.asp_id
  storage_account_name       = var.sa_name
  storage_account_access_key = var.sa_primary_access_key
  version                    = "~3"
  app_settings               = var.app_settings
  https_only                 = true
  identity {
    type         = var.identity_ids != null ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = var.identity_ids
  }
}

resource "azurerm_role_assignment" "sec_role" {
  scope                = azurerm_function_app.thisfunctionapp.id
  role_definition_name = var.azure_role
  principal_id         = var.aad_principal_id
}