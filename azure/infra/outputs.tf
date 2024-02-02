output "aks_aad_client_id" {
  description = "Client ID in Azure AD for AKS App"
  value       = data.azuread_service_principal.aks_aad_server.client_id
}

output "aks_cluster_host" {
  value     = sensitive(data.azurerm_kubernetes_cluster.main.kube_config[0].host)
  sensitive = true
}

output "aks_cluster_ca_cert" {
  description = "Base64 encoded CA Cert for AKS cluster"
  value       = sensitive(data.azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)
  sensitive   = true
}

output "resource_group_name" {
  description = "Azure Resource Group name"
  value       = azurerm_resource_group.rg.name
}

output "azure_location" {
  description = "Location where Azure resources are to be created"
  value       = azurerm_resource_group.rg.location
}

output "tenant_id" {
  value = data.azurerm_subscription.current.tenant_id
}

output "aks_admin_sp_id" {
  description = "Service principal application ID to manage AKS cluster"
  value       = azuread_application.aks_admin.client_id
}

output "aks_admin_sp_secret" {
  description = "Service principal secret to manage AKS cluster"
  value       = sensitive(azuread_service_principal_password.aks_admin.value)
  sensitive   = true
}

output "aks_public_ip" {
  description = "Public IP for AKS cluster"
  value       = data.azurerm_public_ip.aks_outgoing.ip_address
}

output "istio_madefor_node_label_value" {
  value = local.default_nodepool_labels.madefor
}