resource "azurerm_user_assigned_identity" "uid" {
  location            = var.location
  name                = "id-${var.use_name}-${var.env}-${var.region}"
  resource_group_name = var.rg_name
}