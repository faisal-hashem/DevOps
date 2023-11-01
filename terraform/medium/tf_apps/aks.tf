module "aks_rg" {
  source          = "~/terraform/tf_modules/azrg"
  rgname          = "aks-rg"
  location        = "centralus"
}

module "aks-cluster-01" {
  source                = "~/terraform/tf_modules/azaks"
  aks_cluster_name      = "my_aks_cluster"
  aks_cluster_location  = "centralus"
  aks_cluster_rg        = module.aks_rg.rg_name
  dns_prefix            = "myakscluster"
  aks_node_pool_name    = "default" 
  aks_node_count        = "1"
  aks_node_vm_size      = "Standard_D2_v2"
}


