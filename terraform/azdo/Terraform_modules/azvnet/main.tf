resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.vnet_location
  resource_group_name = var.rg_name
  address_space       = var.vnet_cidr
  dns_servers         = var.dns_servers
}