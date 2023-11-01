locals {
  required_tags = {
    environment     = var.env
    CreationMethod  = "Terraform"
  }
  netskope_ips = split("\r\n", file("../utility_scripts/resources/netskope_ips.txt"))
  build_subnet_ids = split("\r\n", file("../utility_scripts/resources/build_subnet_ids.txt")) 
}

resource "azurerm_key_vault" "akv" {
  name                        = "kv-${var.use_name}-${var.env}-${var.region}"
  location                    = var.location
  resource_group_name         = var.rg_name
  sku_name                    = var.sku_name
  tenant_id                   = var.tenant_id
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled
  enable_rbac_authorization   = var.azure_rbac_enabled
  tags                        = merge(local.required_tags, var.custom_tags)

   network_acls { 
     default_action = var.acl_allowed_ips != null || var.acl_subnet_ids != null || var.add_netskope_ips || var.add_private_endpoint ? "Deny" : "Allow"            # If any network configuration is supplied, this will default to Deny rather than Allow.
     bypass         = var.enabled_for_disk_encryption ? "AzureServices" : var.acl_bypass                                              # If Enabled for Disk Encryption is True, this mandates "AzureServices" in the Bypass setting
     ip_rules       = (
        var.acl_allowed_ips != null && var.add_netskope_ips == false ? var.acl_allowed_ips :                                          # If acl_allowed_ips were supplied but add_netskope_ips is false, this will add in the acl_allowed_ips to ip_rules
        var.acl_allowed_ips == null && var.add_netskope_ips ? local.netskope_ips :                                                    # If add_netskope_ips is true but acl_supplied_ips is null, the netskope IPs will be supplied to ip_rules
        var.acl_allowed_ips != null && var.add_netskope_ips ? compact(concat(var.acl_allowed_ips, local.netskope_ips)) : null         # If add_netskope_ips is true AND acl_supplied_ips were supplied, those values will be concatenated and supplied to ip_rules
     )                                                                                                                                # If none of these conditions were met, the ip_rules block will be null and default_action will be Allow
     virtual_network_subnet_ids = (
         var.acl_subnet_ids != null ? compact(concat(local.build_subnet_ids, var.acl_subnet_ids)) :                                   # If acl_subnet_ids are supplied, the list of subnets will be concatenated with the build agent subnets. One virtual_networks_rules block per subnet supplied will be created
        (var.add_netskope_ips || var.acl_allowed_ips != null || var.add_private_endpoint) && var.acl_subnet_ids == null ? compact(local.build_subnet_ids) : null  # If add_netskope_ips is true OR acl_allowed_ips were supplied AND no additional subnet IDs, this will add the build agent subnet IDs by default
     )                                                                                                                                # If none of the conditions were met, this will evalute to null
   }
}

resource "azurerm_role_assignment" "akv_role" {
  scope                = azurerm_key_vault.akv.id
  role_definition_name = var.azure_role
  principal_id         = var.aad_principal_id
}

resource "azurerm_private_endpoint" "akv_privateendpoint" {
  count               = var.add_private_endpoint ? 1 : 0
  name                = "pep-akv-${var.use_name}-${var.env}-${var.region}"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id
  tags                = merge(local.required_tags, var.custom_tags)

  private_service_connection {
  name                             = "con-akv-${var.use_name}-${var.env}-${var.region}"
    private_connection_resource_id = azurerm_key_vault.akv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}