locals {
  vnet_name = element(split("/",var.subnetid),8)
  bastion_name = "bastion_${local.vnet_name}"
}

resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion_pip_${local.vnet_name}"
  location            = var.location
  resource_group_name = var.rgname
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = local.bastion_name
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnetid
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}