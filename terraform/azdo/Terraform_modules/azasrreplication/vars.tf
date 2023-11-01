variable "asr_vault_rg" {
    type = string
}

variable "asr_vault_name" {
    type = string
}

variable "asr_fabric_primary_name" {
    type = string
}

variable "asr_container_primary_name" {
    type = string
}

variable "asr_fabric_secondary_id" {
    type = string
}

variable "asr_container_secondary_id" {
    type = string
}

variable "asr_cache_storage_id" {
    type = string
}

variable "asr_policy_id" {
    type = string
}

variable "vm_rg_id" {
    type = string
}

variable "vm_id" {
    type = string
}

variable "disk_ids" {
}

variable "vm_nic_id" {
    type = string
}

variable "subnet_secondary_name" {
    type = string
}

variable "vm_name" {
    type = string
}

variable "disktype" {
    type = string
    default = "Standard_LRS"
}