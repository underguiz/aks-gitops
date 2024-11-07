variable "resource_group" {
  type    = string
  default = "aks-gitops"
}

output "managed_identity_id" {
  value       = azurerm_user_assigned_identity.tf-controller-managed-id.client_id
  description = "TF Controller Managed Identity Client ID"
}