resource "azurerm_windows_virtual_machine" "vm" {
  count = "${length(var.vm_names)}"
  #for_each = {for vm in var.vm_names: => vm }
  name                  = "${element(var.vm_names,count.index)}"
  location              = var.rg.location
  resource_group_name   = var.rg.name
  network_interface_ids = var.nic.id
  size                  = var.vmsize
  admin_username        = "bossaccount"
  admin_password        = "B0ssM@n2021"

 source_image_reference {
    publisher = "microsoftwindowsserver"
    offer     = "windowsserver"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  } 
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Premium_LRS"
   # managed_disk_type = "Standard_LRS"
  }
}
