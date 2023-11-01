resource "azurerm_network_security_group" "nsg" {
  name                = "nsg_${var.usename}_${var.netenvironment}_${var.region}"
  location            = var.location
  resource_group_name = var.rgname
  }