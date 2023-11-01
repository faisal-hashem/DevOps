variable "rg_name" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "env" {
  type = string
}
variable "use_case" {
  type = string
  default = "shared"
}
variable "region" {
  type = string
}
variable "instance" {
  type = string
  default = "00"
}