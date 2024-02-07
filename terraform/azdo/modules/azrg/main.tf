locals {
  required_tags = {
    environment     = var.env
    CreationMethod  = "Terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.rglocation
  tags     = merge(local.required_tags, var.custom_tags)
}
