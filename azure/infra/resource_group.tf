resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.region
}

data "azurerm_subscription" "current" {}