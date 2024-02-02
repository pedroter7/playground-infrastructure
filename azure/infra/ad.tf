data "azuread_client_config" "current" {}

data "azuread_service_principal" "aks_aad_server" {
  display_name = "Azure Kubernetes Service AAD Server"
}

resource "azuread_application" "aks_admin" {
  display_name = var.aks_admin_sp_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "aks_admin" {
  client_id = azuread_application.aks_admin.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "aks_admin" {
  service_principal_id = azuread_service_principal.aks_admin.id
  end_date             = "2099-01-01T00:00:00Z"
}

resource "azuread_group" "aks_admins" {
  display_name     = "${var.prefix}-aks-admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = [
    data.azuread_client_config.current.object_id,
    azuread_service_principal.aks_admin.object_id,
  ]
}

