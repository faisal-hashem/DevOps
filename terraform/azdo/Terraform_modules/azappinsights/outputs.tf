output "instrumentation_key" {
  value = azurerm_application_insights.app_insights.instrumentation_key
}
output "connection_string" {
  value = azurerm_application_insights.app_insights.connection_string
}

output "app_id" {
  value = azurerm_application_insights.app_insights.app_id
}
