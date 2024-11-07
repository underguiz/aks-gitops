resource "random_string" "storage-account" {
  length           = 6
  special          = false
  upper            = false
}

resource "azurerm_storage_account" "workload-storage" {
  name                     = "workloadstorage${random_string.storage-account.result}"
  resource_group_name      = data.azurerm_resource_group.gitops-workload-rg.name
  location                 = data.azurerm_resource_group.gitops-workload-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "blobs" {
  name                  = "blobs"
  storage_account_name  = azurerm_storage_account.workload-storage.name
  container_access_type = "private"
}