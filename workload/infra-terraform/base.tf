provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "gitops-workload-rg" {
    name = "gitops-workload-rg"
}