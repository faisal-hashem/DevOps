resource "azurerm_subnet" "azsn4ase" {
  name                 = var.sn_name
  resource_group_name  =  var.rg_name
  virtual_network_name = var.vnet
  address_prefixes     = [var.sn_cidr]
  enforce_private_link_endpoint_network_policies = var.private_link_endpoint_policy_enforcement
  enforce_private_link_service_network_policies = var.private_link_service_policy_enforcement
  service_endpoints = ["Microsoft.EventHub","Microsoft.Sql","Microsoft.Storage","Microsoft.CognitiveServices"]
  delegation {
    name = "delegation"
    service_delegation {
      name             = var.service_delegation_name != null ? var.service_delegation_name : null
      actions          = var.service_delegation_actions != null ? var.service_delegation_actions : null
    }
  }
}
