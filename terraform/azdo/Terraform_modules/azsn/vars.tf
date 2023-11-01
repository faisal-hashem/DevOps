variable "sn_cidr" {
   type = string
   default = "10.110.2.0/24"
}
variable "rg_name" {
  type = string
  default = "default"
}
variable "sn_name" {
  type = string
}
variable "vnet" {
  type = string
}
variable "private_link_endpoint_policy_enforcement" {
  type = bool
   default = null
}

variable "private_link_service_policy_enforcement" {
  type = bool 
  default = null
 }

variable "service_endpoints" {
  type    = list(string)
  description = "This should be all of the Service Endpoints to be used with the subnet"
}
