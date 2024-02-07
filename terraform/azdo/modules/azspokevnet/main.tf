#Add a provider, with alias, for any spokes that will be modified
provider "azurerm" {
  alias = "spoke_azurerm"
  features {}
  subscription_id = var.spoke_subscription_id
}

resource "azurerm_virtual_network" "spokevnet" {
  name                = var.vnet_name
  location            = var.vnet_location
  resource_group_name = var.rg_name
  address_space       = var.vnet_cidr
  dns_servers         = var.dns_servers
  provider            = azurerm.spoke_azurerm
}

output "vnet_id" {
  value = azurerm_virtual_network.spokevnet.id
  
}
output "vnet_name" {
  value = azurerm_virtual_network.spokevnet.name
}
