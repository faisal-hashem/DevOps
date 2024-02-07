resource "azurerm_network_interface" "nic" {
  count = length(var.vm_names)
  name                = element(var.vm_names,count.index)-nic
  location            = var.vm_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}