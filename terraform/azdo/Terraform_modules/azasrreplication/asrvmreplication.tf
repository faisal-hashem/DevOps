resource "azurerm_site_recovery_replicated_vm" "vm-replication" {
  name                                      = "${var.vm_name}-ASR"
  resource_group_name                       = var.asr_vault_rg
  recovery_vault_name                       = var.asr_vault_name
  source_recovery_fabric_name               = var.asr_fabric_primary_name
  source_vm_id                              = var.vm_id
  recovery_replication_policy_id            = var.asr_policy_id
  source_recovery_protection_container_name = var.asr_container_primary_name

  target_resource_group_id                = var.vm_rg_id
  target_recovery_fabric_id               = var.asr_fabric_secondary_id
  target_recovery_protection_container_id = var.asr_container_secondary_id

  dynamic "managed_disk" {
    for_each                     = var.disk_ids
    content {
      disk_id                    = lower(managed_disk.value)
      staging_storage_account_id = var.asr_cache_storage_id
      target_resource_group_id   = var.vm_rg_id
      target_disk_type           = var.disktype
      target_replica_disk_type   = var.disktype
    }
  }

  network_interface {
    source_network_interface_id   = var.vm_nic_id
    target_subnet_name            = var.subnet_secondary_name
    #recovery_public_ip_address_id = azurerm_public_ip.secondary.id
  }

/*
  managed_disk {
    disk_id                    = azurerm_virtual_machine.vm.storage_os_disk[0].managed_disk_id
    staging_storage_account_id = var.asr_cache_storage_id
    target_resource_group_id   = var.vm_rg_id
    target_disk_type           = "Premium_LRS"
    target_replica_disk_type   = "Premium_LRS"
  }

  depends_on = [
    azurerm_site_recovery_protection_container_mapping.container-mapping,
    azurerm_site_recovery_network_mapping.network-mapping,
  ]
*/

}