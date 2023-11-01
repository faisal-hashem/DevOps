#Add a provider, with alias, for any spokes that will be modified
provider "azurerm" {
  alias = "spoke_azurerm"
  features {}
  subscription_id = var.spoke_subscription_id
}

resource "azurerm_subnet" "azsn" {
  name                 = var.sn_name
  resource_group_name =  var.rg_name
  virtual_network_name = var.vnet
  address_prefixes     = [var.sn_cidr]
  enforce_private_link_endpoint_network_policies = var.private_link_endpoint_policy_enforcement
  enforce_private_link_service_network_policies = var.private_link_service_policy_enforcement
  service_endpoints = ["Microsoft.Storage"]
}
output sn_id {
  value = azurerm_subnet.azsn.id
}
