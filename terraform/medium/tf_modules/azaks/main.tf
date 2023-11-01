resource "azurerm_kubernetes_cluster" "akscluster" {
  name                = var.aks_cluster_name
  location            = var.aks_cluster_location
  resource_group_name = var.aks_cluster_rg
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = var.aks_node_pool_name
    node_count = var.aks_node_count
    vm_size    = var.aks_node_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

}