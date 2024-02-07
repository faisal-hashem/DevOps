resource "azurerm_storage_container" "container_storage" {
  name                  = var.container_name
  storage_account_name  = var.storage_account_name
  container_access_type = var.container_access_type
}