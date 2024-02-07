# Using the azlinuxm module
This module will deploy a Linux Virtual Machine, either from a standard distribution or an Azure Marketplace image.


## Example Usage
If the machine requires additional disks to be attached, create a local variable where the module will be called using the same structure below.  This local variable should then be passed into ```disk_config``` for the module. 
In this example, "disk2" will be used in the disk resource name.
```
locals {
  disks = {
    "disk2" = {
       size = 256
       caching = "ReadOnly"
       storage_account_type = "Premium_LRS"
    } # end of disk2
    "disk3" = {
       size = 128
       caching = "ReadWrite"
       storage_account_type = "Premium_LRS"
    } # end of disk3    
  } # end of disks
} # end of locals 
```

Module Usage for VM Creation
```
module "linuxvm" {
  source          = "git@ssh.dev.azure.com:v3/MYCOMP/Terraform/Terraform_modules//azlinuxvm?ref=verX.X"
  usename         = "linuxvm01"
  location        = var.location
  region          = var.region
  environment     = var.env
  subscription_id = var.subscription_id
  rgname          = module.resourcegroup.rg_name
  subnetid        = var.subnet_id
  offer           = "0001-com-ubuntu-server-jammy"
  publisher       = "Canonical"
  sku             = "22_04-lts-gen2"
  vmsize          = "Standard_D16ds_v4"
  imageversion    = "latest"
  adminuser       = var.adminuser
  adminpass       = var.adminpassword
  primarydisksize = 30
  disk_config     = local.disks
  ssh_admin_username = var.ssh_admin_username
  ssh_public_key = azurerm_ssh_public_key.sshkey.public_key
}
```