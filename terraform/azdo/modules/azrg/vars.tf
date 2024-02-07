variable "rgname" {
type = string
  default = "defaultrg"
}
variable "rglocation" {
    type = string
    default = "eastus"
}

variable "custom_tags" {
  default = null
  description = "Provide any additional desired tags to be applied to all resources"
}

variable "env" {
  type = string
}