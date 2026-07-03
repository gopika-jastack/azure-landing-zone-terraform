####################################################
# Resource Group
####################################################

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

####################################################
# Hub VNet
####################################################

resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/24"]
}

####################################################
# Web Spoke
####################################################

resource "azurerm_virtual_network" "web" {
  name                = var.web_vnet
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "web" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.web.name
  address_prefixes     = ["10.1.1.0/24"]
}

####################################################
# App Spoke
####################################################

resource "azurerm_virtual_network" "app" {
  name                = var.app_vnet
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.app.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_subnet" "db" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.app.name
  address_prefixes     = ["10.2.2.0/24"]
}

####################################################
# Hub -> Web Peering
####################################################

resource "azurerm_virtual_network_peering" "hub_to_web" {
  name                      = "hub-to-web"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.web.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

####################################################
# Web -> Hub Peering
####################################################

resource "azurerm_virtual_network_peering" "web_to_hub" {
  name                      = "web-to-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.web.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

####################################################
# Hub -> App Peering
####################################################

resource "azurerm_virtual_network_peering" "hub_to_app" {
  name                      = "hub-to-app"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.app.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

####################################################
# App -> Hub Peering
####################################################

resource "azurerm_virtual_network_peering" "app_to_hub" {
  name                      = "app-to-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.app.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
