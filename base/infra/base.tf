provider "azurerm" {
  features {}
}

provider "kubernetes" {
    host = "${azurerm_kubernetes_cluster.aks.kube_config.0.host}"

    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)}"
}

data "azurerm_resource_group" "aks-gitops" {
    name = var.resource_group
}

resource "azurerm_resource_group" "gitops-workload" {
  name     = "gitops-workload-rg"
  location = data.azurerm_resource_group.aks-gitops.location
}