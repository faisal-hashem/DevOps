locals {
  vmname = "${var.region}${substr(var.environment,0,1)}-${var.usename}"
  default_tags = {
    Environment = var.environment
    CreationMethod = "Terraform"
  }
  linux_patching = {
    bypass_platform_safety_checks_on_user_schedule_enabled = var.enable_patching ? true : false
    patch_assessment_mode = var.enable_patching ? "AutomaticByPlatform" : "ImageDefault"
    patch_mode            = var.enable_patching ? "AutomaticByPlatform" : "ImageDefault"
  }
}

resource "azurerm_network_interface" "linuxvmnic" {
  name                = "${local.vmname}-nic"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "${local.vmname}-nic"
    subnet_id                     = var.subnetid
    private_ip_address_allocation = var.static_ip_address != null ? "Static" : "Dynamic"
    private_ip_address            = var.static_ip_address != null ? var.static_ip_address : null
  }

}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                =  local.vmname
  resource_group_name = var.rgname
  location            = var.location
  size                = var.vmsize
  admin_username      = var.adminuser
  admin_password      = var.adminpass #var.disable_password_authentication ? null : var.adminpass
  allow_extension_operations = true
  disable_password_authentication = var.disable_password_authentication
  availability_set_id = var.availability_set_id
  bypass_platform_safety_checks_on_user_schedule_enabled = local.linux_patching.bypass_platform_safety_checks_on_user_schedule_enabled
  patch_assessment_mode = local.linux_patching.patch_assessment_mode
  patch_mode            = local.linux_patching.patch_mode
  
  network_interface_ids = [
    azurerm_network_interface.linuxvmnic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
    disk_size_gb         = var.primarydisksize
  }

  dynamic "plan" {  # This block is only necessary for marketplace VM images, enabled by the for_each condition
    for_each = var.is_marketplace_image ? [1] : []
    content {
      name      = var.plan_name != null ? var.plan_name : var.sku   # if a plan name is not supplied, the var.sku will be put into this field
      publisher = var.publisher
      product   = var.product != null ? var.product : var.offer     # if a product is not supplied, var.offer will be put into this field
    }
  }

  dynamic identity {
    for_each = var.identitytype != null && var.identityid != null ? [1] : []
    content {
      type          = var.identitytype
      identity_ids  = [var.identityid]
    }
  }    

  dynamic admin_ssh_key {
    for_each = var.ssh_admin_username != null && var.ssh_public_key != null ? [1] : []
    content {
      username = var.ssh_admin_username
      public_key = var.ssh_public_key
    }
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.imageversion
   }

  dynamic boot_diagnostics {
    for_each = var.disable_boot_diagnostics && var.boot_diag_uri == null ? [] : ["Enabled"]
    content {
      storage_account_uri = var.boot_diag_uri
    }
  }

  custom_data = var.custom_data
  user_data   = var.user_data
  
  tags = merge(local.default_tags, var.custom_tags)

}                  

resource "azurerm_virtual_machine_data_disk_attachment" "diskattachment" {  
  for_each             = var.disk_config != null ? var.disk_config : {}
  managed_disk_id      = azurerm_managed_disk.vmdisk[each.key].id 
  virtual_machine_id   = azurerm_linux_virtual_machine.linuxvm.id
  lun                  = 10 + index(keys(var.disk_config), each.key) # This should automatically compute the LUN based upon the index of the disk in the disk_config map
  caching              = each.value.caching
}

resource "azurerm_managed_disk" "vmdisk" {  
  for_each             = var.disk_config != null ? var.disk_config : {}    
  name                 = "${local.vmname}-${each.key}"
  location             = var.location 
  resource_group_name  = var.rgname
  storage_account_type = each.value.storage_account_type
  create_option        = "Empty"  
  disk_size_gb         = each.value.size

  lifecycle {
    ignore_changes = [
      create_option, 
      hyper_v_generation,
      source_resource_id,

    ]
  }

 }  

/* -- Example local for additional disk creation
locals {
  disks = {
    "disk2" = {
      size = 200
      caching = whatever
      storage_account_type = whatever
    }
  }
} 
*/