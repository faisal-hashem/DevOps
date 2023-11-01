resource "azurerm_databricks_workspace" "adb" {
  name                                  = var.dbks_instance_name
  resource_group_name                   = var.rg_name
  location                              = var.location
  sku                                   = var.sku
  public_network_access_enabled         = var.public_network_access_enabled
  network_security_group_rules_required = var.network_security_group_rules_required

  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = var.vnet_id
    public_subnet_name                                   = var.public_subnet_name
    private_subnet_name                                  = var.private_subnet_name
    public_subnet_network_security_group_association_id  = "${var.vnet_id}/subnets/${var.public_subnet_name}"
    private_subnet_network_security_group_association_id = "${var.vnet_id}/subnets/${var.private_subnet_name}"
  }
}
