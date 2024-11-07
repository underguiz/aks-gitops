resource "kubernetes_namespace" "workload" {
  metadata {
    name = "workload"
  }
}

resource "kubernetes_namespace" "cluster-config" {
  metadata {
    name = "cluster-config"
  }
}

resource "azurerm_user_assigned_identity" "tf-controller-managed-id" {
  name                = "tf-controller-managed-id"
  resource_group_name = data.azurerm_resource_group.aks-gitops.name 
  location            = data.azurerm_resource_group.aks-gitops.location
}

resource "kubernetes_service_account" "gitlab-managed-id-sa" {
  metadata {
    name = "tf-controller-sa"
    namespace = kubernetes_namespace.cluster-config.metadata.0.name
    annotations = {
         "azure.workload.identity/client-id" = azurerm_user_assigned_identity.tf-controller-managed-id.client_id
    }
  }
}

resource "azurerm_federated_identity_credential" "gitlab-managed-id" {
  name                = "tf-controller-managed-id"
  resource_group_name = data.azurerm_resource_group.aks-gitops.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.tf-controller-managed-id.id
  subject             = "system:serviceaccount:cluster-config:tf-controller-sa"
}

resource "azurerm_role_assignment" "workload-rg" {
  scope                = azurerm_resource_group.gitops-workload.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.tf-controller-managed-id.principal_id
  principal_type       = "ServicePrincipal"
}