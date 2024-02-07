locals {
  vmname = "${var.region}${substr(var.env,0,1)}-${var.vmname}"
}

data "azurerm_image" "image" {
    provider            = azurerm.remote
    name                = var.sourceimagename
    resource_group_name = var.sourceimagerg
}


resource "azurerm_network_interface" "vmnic" {
  provider            = azurerm.default
  name                = "${local.vmname}-vmnic"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "${local.vmname}-vmnic"
    subnet_id                     = var.subnetid
    private_ip_address_allocation = "Dynamic"
    # Do we want this to be static potentially?
  }
}

resource "azurerm_virtual_machine" "vm" {
  provider              = azurerm.default
  name                  = local.vmname
  location              = var.location
  resource_group_name   = var.rgname
  vm_size               = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.vmnic.id}"]

  storage_os_disk {
    name          = "${local.vmname}-osdisk"
    os_type       = var.ostype
    caching       = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = var.manageddisktype
    #managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
      id          = "${data.azurerm_image.image.id}"
      #id          = var.sourceimagename
  }

  os_profile {
    computer_name  = local.vmname
    admin_username = var.adminuser
    admin_password = var.adminpassword
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  #boot_diagnostics {
  #  enabled = true
  #  storage_uri = var.bootdiaguri
  #}
}