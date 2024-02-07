#Add a provider, with alias, for any spokes that will be modified
provider "azurerm" {
  alias = "spoke_azurerm"
  features {}
  subscription_id = var.spoke_subscription_id
}

resource "azurerm_virtual_network_peering" "peer" {
  name                      = var.peer_name
  resource_group_name       = var.rg_name
  virtual_network_name      = var.vnet_name
  remote_virtual_network_id = var.remote_vnet_id
  allow_gateway_transit     = var.allow_gateway_transit
  use_remote_gateways       = var.use_remote_gateways
  allow_forwarded_traffic   = var.allow_forwarded_traffic
  provider                  = azurerm.spoke_azurerm
}

output "vnet_id" {
  value = azurerm_virtual_network_peering.peer.id
}
