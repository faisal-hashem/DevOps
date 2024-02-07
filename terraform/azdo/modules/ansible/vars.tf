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
    default = "ansible-IP-here"
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