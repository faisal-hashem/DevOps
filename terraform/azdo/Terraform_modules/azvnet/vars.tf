variable "vnet_name" {
    type = string
    default = "default_vnet"
}
variable "vnet_cidr" {
    type = list(string)
    default = [
        "10.110.0.0/16",
        ]
}
variable "vnet_location" {
    type = string
    default = "eastus"
  
}
variable "rg_name" {
  type = string
  default = "defaultrg"
}
variable "dns_servers" {
  type = list(string)
  default = null 
}
