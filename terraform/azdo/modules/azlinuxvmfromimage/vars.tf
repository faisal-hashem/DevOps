variable "adminpassword" {
    type = string
    default = "ChangeThisNow!"
}
variable "adminuser" {
    type = string
    default = "mycompadmin"
}
variable "bootdiaguri" {
    default = null
}
variable "env" {}
variable "location" {}
variable "region" {}
variable "rgname" {}
variable "subnetid" {}
variable "vm_size" {}
variable "vmname" {}
variable "galleryimageversionname" {}
variable "galleryimagedefinitionname" {}
variable "galleryname" {}
variable "storageaccounttype" {}
variable "galleryrgname" {}
variable "image_gallery_subscription_id" {
    type = string
    default = "56b07343-7ecb-4de5-a101-5869d15f9619"  #This is the value for prodmgmt where the only Azure Compute Gallery currently is.
    description = "This is the subscription ID for wherever the Azure Compute Image Gallery is located"
}
variable "enablebootdiags" {
    description = "This boolean will enable boot diganostics with a managed account.  Does not need to be used if a storage account URI is supplied for var.bootdiaguri."
    type = bool
    default = false
}