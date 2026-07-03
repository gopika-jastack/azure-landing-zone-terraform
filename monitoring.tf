####################################################
# Log Analytics Workspace
####################################################

resource "azurerm_log_analytics_workspace" "law" {
  name = "law-landingzone"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "PerGB2018"
  retention_in_days = 30
}

####################################################
# Action Group
####################################################

resource "azurerm_monitor_action_group" "email" {
  name = "ag-landingzone"
  resource_group_name = azurerm_resource_group.rg.name
  short_name = "alerts"
  email_receiver {
    name = "Admin"
    email_address = "gopikashree2000@gmail.com"
  }
}

####################################################
# CPU Alert
####################################################

resource "azurerm_monitor_metric_alert" "cpu" {
  name = "HighCPU"
  resource_group_name = azurerm_resource_group.rg.name
  scopes = [
    azurerm_linux_virtual_machine.web_vm.id
  ]
  description = "CPU usage greater than 80%"
  severity = 2
  frequency   = "PT5M"
  window_size = "PT5M"
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name = "Percentage CPU"
    aggregation = "Average"
    operator = "GreaterThan"
    threshold = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
}
