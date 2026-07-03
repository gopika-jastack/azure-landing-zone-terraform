####################################################
# Public IP - Web VM
####################################################

resource "azurerm_public_ip" "web_pip" {
  name                = "web-vm-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Static"
  sku               = "Standard"
}

####################################################
# Network Interface - Web VM
####################################################

resource "azurerm_network_interface" "web_nic" {
  name                = "web-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_pip.id
  }
}

####################################################
# Network Interface - App VM
####################################################

resource "azurerm_network_interface" "app_nic" {
  name                = "app-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }
}

####################################################
# Web VM
####################################################

resource "azurerm_linux_virtual_machine" "web_vm" {

  name                = var.web_vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  size = "Standard DS1 v2"

  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.web_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "WindowsServer"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

####################################################
# App VM
####################################################

resource "azurerm_linux_virtual_machine" "app_vm" {

  name                = var.app_vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  size = "Standard DS1 v2"

  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.app_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "WindowsServer"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
