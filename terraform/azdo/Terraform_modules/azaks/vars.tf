variable "env" {
    type = string
}

variable "rgname" {
    type = string
}

variable "node_rgname" {
    type = string
}

variable "use_name" {
    type = string
}

variable "region" {
    type = string
}

variable "location" {
    type = string
}

variable "node_count" {
    type = string
}

variable "node_size" {
    type = string
}

variable "min_count" {
    type = string
}

variable "max_count" {
    type = string
}

variable "subnet_id" {
    type = string
}

variable "secret_rotation_enabled" {
    type = string
}

variable "aks_network" {
    type = string
    default = "kubenet"
}

variable "dns_service_ip" {
    type = string
}

variable "service_cidr" {
    type = string
}

variable "load_balancer_sku" {
    type = string
}

variable "custom_tags" {
  default = null
}

variable "aksvnetid" {
    type = string
}

variable "sku_tier" {
    type = string
}