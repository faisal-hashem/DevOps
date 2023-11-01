#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
#https://github.com/kpatnayakuni/azure-quickstart-terraform-configuration/blob/master/101-vm-from-sig/main.tf

locals {
  vmname = "${var.region}${substr(var.env,0,1)}-${var.vmname}"
}

provider "azurerm" {
  alias = "image_gallery"
  features {}
  subscription_id = var.image_gallery_subscription_id
}

# Information about existing shared image version
data "azurerm_shared_image_version" "imageversion" {
  provider            = azurerm.image_gallery
  name                = var.galleryimageversionname
  image_name          = var.galleryimagedefinitionname
  gallery_name        = var.galleryname
  resource_group_name = var.galleryrgname
}

resource "azurerm_network_interface" "vmnic" {
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

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = local.vmname
  location              = var.location
  resource_group_name   = var.rgname
  size                  = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.vmnic.id}"]
  admin_username        = var.adminuser
  admin_password        = var.adminpassword
  source_image_id       = data.azurerm_shared_image_version.imageversion.id
  disable_password_authentication = false
  lifecycle {
    ignore_changes = [
      # Ignore changes to admin_username
      admin_username,
    ]
  }
  os_disk {
    name          = "${local.vmname}-osdisk"
    caching       = "ReadWrite"
    storage_account_type = var.storageaccounttype
    
  }

  dynamic "boot_diagnostics" {
    for_each = var.bootdiaguri != null || var.enablebootdiags ? [1] : []
    content {
      storage_account_uri = var.bootdiaguri
    }
  }
  #boot_diagnostics {
  #  storage_account_uri = var.bootdiaguri != null ? var.bootdiaguri : null
  #}
}