output "aks_ui_principal_id" {
  value = azurerm_user_assigned_identity.aksidentity.principal_id
}

output "aks_keyvault_ui_object_id" {
  value = azurerm_kubernetes_cluster.akscluster.key_vault_secrets_provider[0].secret_identity[0].object_id
}

/*
output "kube_config" {
  value = azurerm_kubernetes_cluster.akscluster.kube_config_raw
  sensitive = true
}

output "node_pool_id" {
  value = azurerm_kubernetes_cluster.akscluster.default_node_pool[0].id
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.akscluster.id
}

output "fqdn" {
  value = azurerm_kubernetes_cluster.akscluster.fqdn
}
*/