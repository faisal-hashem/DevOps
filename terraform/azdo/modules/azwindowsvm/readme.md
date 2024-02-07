# Using the azwindowsvm module
This module will deploy a Windows Virtual Machine.  This module can deploy a machine, domain join, and trigger a job from PDQ to format drives.


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

Module Usage for Windows VM Creation
```
module "winvm01" {
  source          = "git@ssh.dev.azure.com:v3/MYCOMP/Terraform/Terraform_modules//azwindowsvm?ref=ver3.9"
  usename         = "winvm01"   #cannot be longer than 10 chars since total machine name will be XXXX-WINVMNAME
  location        = var.location
  region          = var.region
  environment     = var.environment
  rgname          = module.winvm_rg.rg_name
  subnetid        = data.terraform_remote_state.mgmtspoke00.outputs.sn00
  vmsize          = "Standard_D4s_v3"
  adminuser       = var.adminuser
  adminpass       = var.adminpassword
  adjoinpassword  = var.adjoinpass
  deploystorageaccountkey = var.deploystorageaccountkey
  # static_ip_address = "${data.terraform_remote_state.mgmtspoke00.outputs.sn00_simple_prefix}.150"
  primarydisksize = 200
  winossku        = "2019-datacenter"
  enable_adjoin   = true
  # format_drives   = false
  pdqdeploypass   = var.pdqdeploypass
  custom_tags     = {Application = "Test VM",Owner = "Infrastructure",Backup = "Polaris-Priority-03"}
  disk_config     = local.disks
}
```