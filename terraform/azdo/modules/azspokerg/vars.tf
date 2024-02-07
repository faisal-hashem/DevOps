variable "rgname" {
type = string
  default = "defaultrg"
}
variable "rglocation" {
    type = string
    default = "eastus"
}
variable "spoke_subscription_id" {
  description = "ID for the target subscription to be used for Spoke VNet."
  type = string
  default = "69bedceb-ae07-433f-8a58-635db0785ff6"
}