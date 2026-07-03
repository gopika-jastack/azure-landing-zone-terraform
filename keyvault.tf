####################################################
# Azure Key Vault
####################################################

resource "azurerm_key_vault" "kv" {

  name = "kvlandingzone${random_integer.rand.result}"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name = "standard"
  enable_rbac_authorization = true
  purge_protection_enabled = false
  soft_delete_retention_days = 7
}

####################################################
# Random Number
####################################################

resource "random_integer" "rand" {
  min = 1000
  max = 9999
}

####################################################
# Client Config
####################################################

data "azurerm_client_config" "current" {}
