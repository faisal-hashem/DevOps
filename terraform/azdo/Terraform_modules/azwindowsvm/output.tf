locals {
    vm_id_trimmed = join("/",slice(split("/",azurerm_windows_virtual_machine.vm.id),0,7))
    os_disk_computed = "${local.vm_id_trimmed}/disks/${azurerm_windows_virtual_machine.vm.os_disk[0].name}"
    data_disks = length(azurerm_managed_disk.vmdisk) > 0 ? [for disk in azurerm_managed_disk.vmdisk : disk.id] : null
    data_disks_splat = length(azurerm_managed_disk.vmdisk) > 0 ? values(azurerm_managed_disk.vmdisk)[*].id : null
    all_disk_ids = length(azurerm_managed_disk.vmdisk) > 0 ? concat([local.os_disk_computed],local.data_disks) : compact([local.os_disk_computed]) 
}

output "disk_ids" {
    value = local.all_disk_ids
}

output "nic_id" {
    value = azurerm_network_interface.vmnic.id
}

output "id" {
    value = azurerm_windows_virtual_machine.vm.id
}

output "os_disk_id" {
    value = local.os_disk_computed
}

output "vm_name" {
    value = azurerm_windows_virtual_machine.vm.name
}