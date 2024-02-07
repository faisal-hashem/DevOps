# Defining acceptable configuration aliases from parent modules per https://www.terraform.io/docs/language/providers/configuration.html #
# Probably doesn't work in this instance since the parent module would then be applying the provider alias to all resources in the module rather than a particular item.  Need to redo this 

terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [ azurerm.default, azurerm.remote ]
    }
  }
}
