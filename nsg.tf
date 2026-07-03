####################################################
# Web NSG
####################################################

resource "azurerm_network_security_group" "web_nsg" {

  name                = "nsg-web"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "80"
  }
}

####################################################
# App NSG
####################################################

resource "azurerm_network_security_group" "app_nsg" {

  name                = "nsg-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {

    name = "Allow-Web"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = "10.1.1.0/24"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "80"
  }
}

####################################################
# Associate NSGs
####################################################

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}
