####################################################
# Resource Group
####################################################

output "resource_group" {
  value = azurerm_resource_group.rg.name
}

####################################################
# Hub VNet
####################################################

output "hub_vnet" {
  value = azurerm_virtual_network.hub.name
}

####################################################
# Web VNet
####################################################

output "web_vnet" {
  value = azurerm_virtual_network.web.name
}

####################################################
# App VNet
####################################################

output "app_vnet" {
  value = azurerm_virtual_network.app.name
}

####################################################
# Web VM Public IP
####################################################

output "web_vm_public_ip" {
  value = azurerm_public_ip.web_pip.ip_address
}

####################################################
# Key Vault URI
####################################################

output "keyvault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}

####################################################
# Log Analytics
####################################################

output "log_analytics_workspace" {
  value = azurerm_log_analytics_workspace.law.name
}
