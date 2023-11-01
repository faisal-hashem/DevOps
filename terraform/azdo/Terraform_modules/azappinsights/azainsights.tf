resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                ="log-${var.use_name}-${var.env}-${var.region}"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
}

resource "azurerm_application_insights" "app_insights" {
  name                = "appi-${var.use_name}-${var.env}-${var.region}"
  location            = var.location
  resource_group_name = var.rg_name
  application_type    = var.application_type
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace.id
}