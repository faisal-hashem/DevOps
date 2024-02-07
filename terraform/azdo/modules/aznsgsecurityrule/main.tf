resource "azurerm_network_security_rule" "nsgrule" {
  name                        = "nsgrule-${var.netenvironment}-${var.region}-${var.direction}-${var.usename}"
  priority                    = var.priority
  direction                   = var.direction
  access                      = var.access
  protocol                    = var.protocol
  source_port_range           = var.source_port_range
  destination_port_range      = var.destination_port_range
  source_address_prefix       = var.source_address_prefix
  destination_address_prefix  = var.destination_address_prefix
  resource_group_name         = var.rgname
  network_security_group_name = var.nsg
}