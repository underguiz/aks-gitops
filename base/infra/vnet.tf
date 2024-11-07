resource "azurerm_virtual_network" "aks-gitops" {
  name                = "aks-gitops"
  resource_group_name = data.azurerm_resource_group.aks-gitops.name 
  location            = data.azurerm_resource_group.aks-gitops.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "aks" {
  name                 = "aks"
  resource_group_name  = data.azurerm_resource_group.aks-gitops.name 
  virtual_network_name = azurerm_virtual_network.aks-gitops.name
  address_prefixes     = ["10.254.0.0/22"]
}