locals {
  required_tags = {
    environment     = var.env
    TFModifiedTime  = "${formatdate("YYYYMMDD_hhmmss ZZZ", timestamp())}"
    CreationMethod  = "Terraform"
  }
  netskope_ips = split("\r\n", file("../utility_scripts/resources/netskope_ips.txt"))
  build_subnet_ids = split("\r\n", file("../utility_scripts/resources/build_subnet_ids.txt"))
  acl_bypass       = "None"
  location         = "eastus"
}

resource "azurerm_cognitive_account" "azcogaccount" {
  name                = "cogacct-${var.use_name}-${var.env}-ue1"
  location            = local.location
  resource_group_name = var.rg_name
  kind                = "OpenAI"
  sku_name            = "S0"
  custom_subdomain_name = "${var.use_name}-${var.env}-ue1"

  network_acls { 
    default_action = var.acl_allowed_ips != null || var.acl_subnet_ids != null || var.add_netskope_ips ? "Deny" : "Allow"           # If any network configuration is supplied, this will default to Deny rather than Allow.
    ip_rules       = (
      var.acl_allowed_ips != null && var.add_netskope_ips == false ? var.acl_allowed_ips :                                          # If acl_allowed_ips were supplied but add_netskope_ips is false, this will add in the acl_allowed_ips to ip_rules
      var.acl_allowed_ips == null && var.add_netskope_ips ? local.netskope_ips :                                                    # If add_netskope_ips is true but acl_supplied_ips is null, the netskope IPs will be supplied to ip_rules
      var.acl_allowed_ips != null && var.add_netskope_ips ? compact(concat(var.acl_allowed_ips, local.netskope_ips)) : null         # If add_netskope_ips is true AND acl_supplied_ips were supplied, those values will be concatenated and supplied to ip_rules
   )                                                                                                                                # If none of these conditions were met, the ip_rules block will be null and default_action will be Allow
      
   dynamic "virtual_network_rules" {
      for_each = (
          var.acl_subnet_ids != null ? compact(concat(local.build_subnet_ids, var.acl_subnet_ids)) :                                # If acl_subnet_ids are supplied, the list of subnets will be concatenated with the build agent subnets. One virtual_networks_rules block per subnet supplied will be created
         (var.add_netskope_ips || var.acl_allowed_ips != null) && var.acl_subnet_ids == null ? compact(local.build_subnet_ids) : [] # If add_netskope_ips is true OR acl_allowed_ips were supplied AND no additional subnet IDs, this will add the build agent subnet IDs by default
      )                                                                                                                             # If none of the conditions were met, this will evalute to an empty set [] which will null out the dynamic block and none will be created (effectively a "count" but on a dynamic block where count cannot be used)
       content {
         subnet_id = virtual_network_rules.value
      }
   }
  }
} 