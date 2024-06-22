provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azrg" {
  name     = "az-rg"
  location = "centralus"
}

module "aks" {
  source = "github.com/flavius-dinu/terraform-az-aks.git?ref=v1.0.12"
  kube_params = {
    kube1 = {
      name                = "kube1"
      rg_name             = azurerm_resource_group.azrg.name
      rg_location         = "centralus"
      dns_prefix          = "kube"
      identity            = [{}]
      enable_auto_scaling = false
      node_count          = 1
      np_name             = "kube1"
      export_kube_config  = false
      tags                = {}
    }
  }
}

output "kube_config" {
  value     = module.aks.kube_config["kube1"]
  sensitive = true
}