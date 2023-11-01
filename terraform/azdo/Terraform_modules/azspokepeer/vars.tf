variable "peer_name"{type = string}
variable "rg_name" {type = string}
variable "vnet_name" {type = string}
variable "remote_vnet_id" {type = string}
variable "allow_gateway_transit" {
   type = bool
   default = false
  }
variable "use_remote_gateways" {
   type = bool
   default = false
  }
variable "allow_forwarded_traffic" {
   type = bool
   default = false
  }

variable "spoke_subscription_id" {
  description = "ID for the target subscription to be used for Spoke VNet."
  type = string
  default = "69bedceb-ae07-433f-8a58-635db0785ff6"
}