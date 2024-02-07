locals {
  winvmname = "${var.region}${substr(var.environment,0,1)}-${var.usename}"  #This will automatically create the name to match current naming standards based on use name in module call, e.g. UC1D-VMNAME01
  domain_name = "na.mycompany.com"
  domain_oupath = "OU=${var.region},OU=MYCOMPServers,DC=na,DC=mycompany,DC=com"
  adjoin_user = "FHM\\SVCSCCMNet"

  default_tags = {
   Environment = var.environment
   CreationMethod = "Terraform"
  }
}

resource "azurerm_network_interface" "vmnic" {
  name                = "${local.winvmname}-nic"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "${local.winvmname}-nic"
    subnet_id                     = var.subnetid
    private_ip_address_allocation = var.static_ip_address != null ? "Static" : "Dynamic"
    private_ip_address            = var.static_ip_address != null ? var.static_ip_address : null
  }

}



resource "azurerm_windows_virtual_machine" "vm" {
  name                = local.winvmname
  resource_group_name = var.rgname
  location            = var.location
  size                = var.vmsize
  admin_username      = var.adminuser
  admin_password      = var.adminpass
  allow_extension_operations = true
  availability_set_id = var.availability_set_id
  network_interface_ids = [ azurerm_network_interface.vmnic.id ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_storage_account_type #"Standard_LRS"
    disk_size_gb         = var.primarydisksize
    
    }

  source_image_reference {
    publisher = var.publisher #"MicrosoftWindowsServer"
    offer     = var.offer #"WindowsServer"
    sku       = var.winossku
    version   = var.imageversion #"latest"
  }

  tags = merge(local.default_tags, var.custom_tags)
}

/* -- To use the following disk attachment block, provide var.disk_config as follows:
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

resource "azurerm_virtual_machine_data_disk_attachment" "vmsecondarydiskattach" {  
  for_each             = var.disk_config != null ? var.disk_config : {}
  managed_disk_id      = azurerm_managed_disk.vmdisk[each.key].id 
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  lun                  = 10 + index(keys(var.disk_config), each.key) #
  caching              = each.value.caching
}

resource "azurerm_managed_disk" "vmdisk" {  
  for_each             = var.disk_config != null ? var.disk_config : {}    
  name                 = "${local.winvmname}-${each.key}"
  location             = var.location 
  resource_group_name  = var.rgname
  storage_account_type = each.value.storage_account_type
  create_option        = "Empty"  
  disk_size_gb         = each.value.size

  lifecycle {
    ignore_changes = [
      create_option, 
      hyper_v_generation,
      source_resource_id
    ]
  }

}     


resource "azurerm_virtual_machine_extension" "fhdomainjoin" {
  count = var.enable_adjoin ? 1 : 0
  depends_on = [azurerm_windows_virtual_machine.vm]
  name                 = "fhdomainjoin"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  settings = jsonencode(
    {
    "Name": "${local.domain_name}",
    "OUPath": "${local.domain_oupath}",
    "User": "${local.adjoin_user}",
    "Restart": "true",
    "Options": "3"
    }
)
  protected_settings = jsonencode(
    {
      "Password": "${var.adjoinpassword}"
    }
  )
}

/*  This stuff needs to be updated for root romain join properties (OU, User Account and User Password)
resource "azurerm_virtual_machine_extension" "fhrootdomainjoin" {
  count = var.enable_rootdomainjoin ? 1 : 0
  depends_on = [azurerm_windows_virtual_machine.vm]
  name                 = "fhrootdomainjoin"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  settings = jsonencode(
    {
"Name": "mycompany.com",
#"OUPath": "OU=${var.region},OU=MYCOMPServers,DC=mycompany,DC=com",
"OUPath": "CN=Computers,DC=mycompany,DC=com",  #-- We currently have no machines in the root EXCEPT for Domain Controllers, so they're all moved to 'Domain Controllers' once promoted.
"User": "FHM\\SVCSCCMNet",
"Restart": "true",
"Options": "3"
    }
)
  protected_settings = jsonencode(
    {
      "Password": "${var.adjoinpassword}"
    }
  )
}
*/

resource "azurerm_virtual_machine_extension" "pdqdriveformatting" {
  count                = var.format_drives && var.disk_config != null ? 1 : 0
  name                 = "${local.winvmname}-drive-formatting"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  auto_upgrade_minor_version = true
  depends_on = [
    azurerm_virtual_machine_extension.fhdomainjoin, 
    azurerm_virtual_machine_data_disk_attachment.vmsecondarydiskattach
  ]
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File InvokeDriveConfig.ps1 ${var.pdqdeploypass}",
      "StorageAccountName": "FHMroddeploy",
      "storageAccountKey": "${var.deploystorageaccountkey}",
      "fileUris": [
        "https://FHMroddeploy.blob.core.windows.net/powershell/InvokeDriveConfig.ps1"
      ]
          
    }
  PROTECTED_SETTINGS
}

resource "azurerm_virtual_machine_extension" "setnewbuildregkey" {  # If the machine does not require additional disks, it will still get the new build key for standard PDQ packages
    count = var.disk_config == null || var.format_drives == false ? 1 : 0
    name                 = "${local.winvmname}-set-newbuildregkey"
    virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.9"
    auto_upgrade_minor_version = true

    settings = <<SETTINGS
    {
        "commandToExecute" : "powershell -command New-Item HKLM:/Software/FH -Force ; New-ItemProperty -Path HKLM:/Software/FH -Name NewBuild -Value 1 -PropertyType DWORD ; exit 0"
        
    }
    SETTINGS
}

/*
resource "azurerm_virtual_machine_extension" "bginfo" {
  count = var.enable_bginfo ? 1 : 0
  name                 = "${local.winvmname}-bginfo"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "BGInfo"
  type_handler_version = "2.1"
  settings = jsonencode({
      "configurationUrl": "https://FHMroddeploy.blob.core.windows.net/bginfo/Bginfo.bgi"
  })
  protected_settings = jsonencode({
      "storageAccountName": "FHMroddeploy",
      "storageAccountKey": "${var.deploystorageaccountkey}",

    })
  

  depends_on = [azurerm_windows_virtual_machine.vm]
}
*/

# resource "azurerm_virtual_machine_extension" "vmextension" {
#   name                       = "winvm_encrypt_extension"
#   virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
#   publisher                  = "Microsoft.Azure.Security"
#   type                       = "AzureDiskEncryption"
#   type_handler_version       = "2.2"
#   auto_upgrade_minor_version = true

#   settings = <<SETTINGS
#     {
#         "EncryptionOperation": "EnableEncryption",
#         "KeyVaultURL": "${var.azkeyvaulturl}",
#         "KeyVaultResourceId": "${var.azkeyvaultresourceid}",					
#         "KeyEncryptionKeyURL": "${var.azkeyvaulturl}keys/${var.azkeyname}/${var.azkeyversion}",
#         "KekVaultResourceId": "${var.azkekvaultresourceid}",					
#         "KeyEncryptionAlgorithm": "RSA-OAEP",
#         "VolumeType": "ALL"
#     }
# SETTINGS

# }
# resource "azurerm_virtual_machine_extension" "postinstallscript" {
#   name                 = "${local.winvmname}"
#   virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.10"

#   protected_settings = jsonencode(
#     {
#       "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File azpostdeploy.ps1 -pass ${var.pdqdeploypass} ",
#       "StorageAccountName": "FHMroddeploy",
#       "storageAccountKey": "${var.deploystorageaccountkey}",
#       "fileUris": [
#                 "https://FHMroddeploy.blob.core.windows.net/powershell/azpostdeploy.ps1"
#             ]
#     }
# )
# depends_on = [azurerm_virtual_machine_extension.fhdomainjoin]
# }