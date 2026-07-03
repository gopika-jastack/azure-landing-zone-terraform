variable "resource_group_name" {
  default = "rg-landingzone-demo"
}

variable "location" {
  default = "East US"
}

variable "hub_vnet" {
  default = "hub-vnet"
}

variable "web_vnet" {
  default = "spoke-web-vnet"
}

variable "app_vnet" {
  default = "spoke-app-vnet"
}

variable "web_vm_name" {
  default = "vm-web"
}

variable "app_vm_name" {
  default = "vm-app"
}

variable "admin_username" {
  default = "azureuser"
}

variable "admin_password" {
  description = "VM Administrator Password"
  sensitive   = true
}
