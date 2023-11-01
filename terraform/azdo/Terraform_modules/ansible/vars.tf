variable "playbook_file" {
    type = string
}

variable "vmprivateip" {
    type = string
}

variable "adminuser" {
    type = string
}

variable "adminpassword" {
    type = string
}

variable "ansible_control_ip" {
    type = string
    default = "10.225.20.8"
}

variable "vm_id" {
    type = string
}

variable "ansible_key" {
    type = string
}

variable "ansible_extra_vars" {
  type        = map(string)
  default     = {}
}