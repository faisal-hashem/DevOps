#Add a provider, with alias, for any spokes that will be modified
provider "azurerm" {
  alias = "spoke_azurerm"
  features {}
  subscription_id = var.spoke_subscription_id
}

resource "azurerm_route_table" "default_routetable" {
  name                          = "default_routetable_${var.region}"
  location                      = var.location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = true
  provider                      = azurerm.spoke_azurerm

  dynamic "route" {
    for_each = local.default_routetable
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_ip
    }
  }
  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_route_table" "ase_routetable" {
  name                          = "ase_routetable_${var.region}"
  location                      = var.location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = true
  provider                      = azurerm.spoke_azurerm

  dynamic "route" {
    for_each = local.ase_routetable
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_ip
    }
  }
  tags = {
    environment = "${var.environment}"
  }
}