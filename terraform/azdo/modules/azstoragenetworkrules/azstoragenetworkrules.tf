resource "azurerm_storage_account_network_rules" "networkrule" {
  storage_account_id = var.storage_account_id
  default_action              = "Deny"
  virtual_network_subnet_ids = [var.public_subnet_id, var.private_subnet_id]
}
