resource "azurerm_kubernetes_cluster" "main" {
  name                         = var.prefix
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  dns_prefix                   = var.aks_dns_prefix
  kubernetes_version           = var.kubernetes_version
  local_account_disabled       = true
  sku_tier                     = "Free"
  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 72

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  default_node_pool {
    name                = "akspool"
    vm_size             = "Standard_D2s_v3"
    os_sku              = "Ubuntu"
    enable_auto_scaling = false
    node_count          = 1
    os_disk_size_gb     = 30
    vnet_subnet_id      = azurerm_subnet.aks_default_nodepool.id

    node_labels = local.default_nodepool_labels

  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = concat([azuread_group.aks_admins.object_id], var.extra_aks_admin_groups)
    azure_rbac_enabled     = true
    tenant_id              = data.azurerm_subscription.current.tenant_id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }
}

data "azurerm_kubernetes_cluster" "main" {
  name                = azurerm_kubernetes_cluster.main.name
  resource_group_name = azurerm_resource_group.rg.name
}
