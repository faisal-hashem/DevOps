locals {
  vm_id_trimmed = join("/",slice(split("/",azurerm_linux_virtual_machine.linuxvm.id),0,7))
  os_disk_name = azurerm_linux_virtual_machine.linuxvm.os_disk[0].name
  data_disks = length(azurerm_managed_disk.vmdisk) > 0 ? [for disk in azurerm_managed_disk.vmdisk : disk.id] : null
  data_disks_2 = length(azurerm_managed_disk.vmdisk) > 0 ? values(azurerm_managed_disk.vmdisk)[*].id : null # How to retrieve with splatting
  os_disk_id = "${local.vm_id_trimmed}/disks/${local.os_disk_name}"
  disk_ids = length(azurerm_managed_disk.vmdisk) > 0 ? concat([local.os_disk_id],local.data_disks) : compact([local.os_disk_id])
}
output "vm_id" {
  value = azurerm_linux_virtual_machine.linuxvm.id
}

output "nic_id" {
  value = azurerm_network_interface.linuxvmnic.id
}

output "os_disk_id" {
  value = local.os_disk_id
}

output "all_disk_ids" {
  value = local.disk_ids
}

output "vm_private_ip" {
  value = azurerm_network_interface.linuxvmnic.private_ip_address
}