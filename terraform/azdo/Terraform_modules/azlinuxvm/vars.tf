variable "location" {}
variable "rgname" {}
variable "subnetid" {}
variable "vmsize" {}
variable "usename" {
    validation {
        condition     = length(var.usename) < 11 
        error_message = "The usename value must be 10 or less characters."
    }
}
variable "adminuser" {}
variable "adminpass" {
    default = null
}
variable "primarydisksize" {}
variable "region" {}
variable "storage_account_type" {
    default = "Standard_LRS"
}
variable "disable_password_authentication" {
    default = false
    type = bool
}
variable "publisher" {
    default = "OpenLogic"
} 
variable "offer" {
    default = "CentOS"
}
variable "sku"  {
    default = "8_2"
}
variable "imageversion" {}

variable "static_ip_address" {
    default = null
}

variable "environment" {}

variable "subscription_id" {
    default = null
}

variable "is_marketplace_image" {
    type = bool
    default = false
}

variable "custom_tags" {
    default = null
}

variable "availability_set_id" {
    type = string
    default = null
}

variable "custom_data" {
    default = null
}

variable "user_data" {
    default = null
}

variable "plan_name" {
    default = null
    description = "used in the plan block for a linux vm from the Azure Marketplace"
}

variable "product" {
    default = null
    description = "used in the plan block for a linux vm from the Azure Marketplace."
}

variable "ssh_admin_username" {
    default = null
}

variable "ssh_public_key" {
    default = null
}

variable "identitytype" {
    default = null
    type = string
}

variable "identityid" {
    default = null
    type = string
}

variable "disk_config" {
    default = null
}

variable "boot_diag_uri" {
    default = null
    description = "Endpoint/URI of the Storage Account to store boot diagnostics"
}

variable "disable_boot_diagnostics" {
    default = false
    type = bool
    description = "If boot diagnostics are not desired, setting this to true will remove boot diagnostics"
}

variable "enable_patching" {
    default = false
    type = bool
}