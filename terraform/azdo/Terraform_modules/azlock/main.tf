resource "azurerm_management_lock" "resource_lock" {
  name       = uuid()
  scope      = var.resource_id
  lock_level = var.lock_level
  notes      = "Lock"
}
