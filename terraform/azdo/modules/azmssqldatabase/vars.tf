variable "use_name"{
    type = string
}

variable "env"{
    type = string
}

variable "region"{
    type = string
}

variable "rg_name"{
    type = string
}

variable "location" {
   type = string
}

variable "subnet_id" {
  type = string
}

variable "enable_private_endpoint" {
  type = bool
  default = true
  description = "Boolean to toggle private endpoint option"
}

variable "private_dns_zone_name" {
  type = string
  default = null
}

variable "private_dns_zone_ids" {
  type = list
  default = null
}

variable "sql_administrator_login" {
  type = string
}

variable "sql_administrator_login_password" {
  type = string
}

variable "database" {
  description = "Map of databases to be created."
  type = map(object({
    collation      = string
    license_type   = string
    max_size_gb    = number
    read_scale     = bool
    sku_name       = string
    zone_redundant = bool
    storage_account_type = string
  }))
  default = {}
}

variable "enable_rubrik_endpoint" {
  type = bool
  default = true
  description = "Boolean to toggle private endpoint onto Rubrik subnet"
}

variable "fw_ip_ranges" {
  default = null
  type = list
  description = "List of IPs to add to MSSQL Firewall.  Must be in CIDR notation"
}

variable "add_netskope_ips" {
  default = false
  type = bool
  description = "Toggles whether or not to include Netskope IPs for firewall."
}

variable "add_build_subnet" {
  default = false
  type = bool
  description = "Toggles whether or not to add the build subnet ID"
}

variable "resource_id" {
  type = string
  default = null
}

variable "subscription_id" {
  type = string
  default = null
}