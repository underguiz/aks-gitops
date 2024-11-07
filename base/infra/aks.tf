resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-gitops"
  dns_prefix          = "aks-gitops"
  resource_group_name = data.azurerm_resource_group.aks-gitops.name 
  location            = data.azurerm_resource_group.aks-gitops.location

  role_based_access_control_enabled = true
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true
  
  default_node_pool {
    name                        = "regular"
    vm_size                     = "Standard_D4s_v5"
    auto_scaling_enabled        = false
    node_count                  = 2
    vnet_subnet_id              = azurerm_subnet.aks.id
    zones                       = [ 1 ]
  }

  network_profile {
    network_plugin      = "azure"
    service_cidr        = "172.29.100.0/24"
    dns_service_ip      = "172.29.100.10"
    network_plugin_mode = "overlay"
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_kubernetes_cluster_extension" "flux" {
  name           = "flux"
  cluster_id     = azurerm_kubernetes_cluster.aks.id
  extension_type = "microsoft.flux"
}

resource "azurerm_role_assignment" "aks-subnet" {
  scope                = azurerm_virtual_network.aks-gitops.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity.0.principal_id
}