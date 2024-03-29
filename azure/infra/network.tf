resource "azurerm_virtual_network" "aks" {
  name                = "${var.prefix}-aks-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "aks_default_nodepool" {
  name                 = "${var.prefix}-default-nodepool"
  virtual_network_name = azurerm_virtual_network.aks.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["10.1.0.0/24"]
}