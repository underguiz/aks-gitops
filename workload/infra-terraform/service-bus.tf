resource "random_string" "servicebus" {
  length           = 6
  special          = false
}

resource "azurerm_servicebus_namespace" "workload" {
  name                = "workload-${random_string.servicebus.result}"
  resource_group_name = data.azurerm_resource_group.gitops-workload-rg.name
  location            = data.azurerm_resource_group.gitops-workload-rg.location
  sku                 = "Standard"
}

resource "azurerm_servicebus_queue" "queue" {
  name         = "queue"
  namespace_id = azurerm_servicebus_namespace.workload.id
}