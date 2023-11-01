locals {
  required_tags = {
    environment     = var.env
    CreationMethod  = "Terraform"
  }
}

resource "azurerm_private_dns_zone" "aksdnszone" {
  name                = "${var.use_name}.privatelink.${var.location}.azmk8s.io"
  resource_group_name = var.rgname
}

resource "azurerm_private_dns_zone_virtual_network_link" "aksdnslink" {
  name                  = "dnslink${var.use_name}${var.region}"
  resource_group_name   = var.rgname
  private_dns_zone_name = azurerm_private_dns_zone.aksdnszone.name
  virtual_network_id    = var.aksvnetid
}

resource "azurerm_user_assigned_identity" "aksidentity" {
  name                = "${var.use_name}-aks-${var.region}-${var.env}-ui"
  resource_group_name = var.rgname
  location            = var.location
}

resource "azurerm_role_assignment" "aksdnsroleassignment" {
  scope                = azurerm_private_dns_zone.aksdnszone.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aksidentity.principal_id
  depends_on           = [azurerm_user_assigned_identity.aksidentity]
}

resource "azurerm_role_assignment" "aksvnetroleassignment" {
  scope                = var.aksvnetid
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aksidentity.principal_id
  depends_on           = [azurerm_user_assigned_identity.aksidentity]
}

resource "azurerm_kubernetes_cluster" "akscluster" {
  name                      = "aks-${var.use_name}-${var.env}-${var.region}"
  location                  = var.location
  resource_group_name       = var.rgname
  node_resource_group       = var.node_rgname
  dns_prefix                = "aks${var.use_name}${var.env}${var.region}dns"
  private_cluster_enabled   = true
  private_dns_zone_id       = azurerm_private_dns_zone.aksdnszone.id
  sku_tier                  = var.sku_tier

  default_node_pool {
    name                    = "${var.use_name}nodepool"
    node_count              = var.node_count
    vm_size                 = var.node_size
    min_count               = var.min_count
    max_count               = var.max_count
    enable_auto_scaling     = true
    vnet_subnet_id          = var.subnet_id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = var.secret_rotation_enabled
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aksidentity.id,
    ]
  }

  azure_active_directory_role_based_access_control {
    managed             = true
    azure_rbac_enabled  = true
  }

  network_profile {
    network_plugin     = var.aks_network
    dns_service_ip     = var.dns_service_ip
    service_cidr       = var.service_cidr
    load_balancer_sku  = var.load_balancer_sku
  }
  
  tags  = merge(local.required_tags, var.custom_tags)

  depends_on = [
    azurerm_role_assignment.aksdnsroleassignment, 
    azurerm_role_assignment.aksvnetroleassignment,
    azurerm_private_dns_zone.aksdnszone,
    azurerm_private_dns_zone_virtual_network_link.aksdnslink,
    azurerm_user_assigned_identity.aksidentity
  ]

}