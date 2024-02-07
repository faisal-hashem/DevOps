variable "location" {}
variable "rgname" {}
variable "environment" {}
variable "subnetid" {}
variable "vmsize" {
  type = string
  description = "Size of the VM to be deployed" 
  }
variable "adminuser" {}
variable "adminpass" {
     type = string
     sensitive = true
}
variable "primarydisksize" {}
variable "usename" {
    validation {
        condition     = length(var.usename) < 11 
        error_message = "The usename value must be 10 or less characters."
    }
}
variable "domainname" {
    type = string
    default = "na.mycompany.com"
}

variable "availability_set_id" {
    type = string
    default = null
}

variable "winossku" {
    type = string
    default = "2019-datacenter"
}
variable "adjoinpassword" {
    type = string
    sensitive = true
}
variable "region" {}
variable "pdqdeploypass" {
    type = string 
    sensitive = true
    default = null
}
variable "deploystorageaccountkey" {
   type = string 
   sensitive = true
   default = null
}
variable "enable_adjoin" {
    type = bool
    default = true
}

variable "enable_rootdomainjoin" {
    type = bool
    default = false
}

variable "format_drives" {
    type = bool
    default = false
    description = "Enabling this variable will provision a vm extension to trigger a PDQ job that moves the page file and format/rename the drive letters"
}

variable "static_ip_address" {
    type = string
    default = null
    description = "Manually assigned static IP."
}

variable "custom_tags" {
    default = null
}

variable "publisher" {
    default = "MicrosoftWindowsServer"
}

variable "offer" {
    default = "WindowsServer"
} 

variable "imageversion" {
    default = "latest"
}

variable "disk_config" {
    default = null
}

variable "os_disk_storage_account_type" {
    default = "Standard_LRS"
}