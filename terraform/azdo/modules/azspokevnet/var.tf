variable "spoke_subscription_id" {
  description = "ID for the target subscription to be used for Spoke VNet."
  type = string
  default = "69bedceb-ae07-433f-8a58-635db0785ff6"
}

variable "vnet_name" {
  description = "Name of the Spoke VNet."  
  type = string
  default = "default_vnet"
}
variable "vnet_cidr" {
  description = "CIDR range for the Spoke VNet." 
  type = list(string)
  default = [
      "10.110.0.0/16",
    ]
}
variable "vnet_location" {
  description = "Location of the Spoke VNet" 
  type = string
  default = "eastus"
  
}
variable "rg_name" {
  description = "Resource Group name for the Spoke Vnet."
  type = string
  default = "defaultrg"
}
variable "dns_servers" {
  description = "Target DNS Servers for Spoke Vnet."
  type = list(string)
  default = null 
}
