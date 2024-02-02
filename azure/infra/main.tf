terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.88.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.47.0"
    }
  }
  cloud {
    workspaces {
      name    = "infrastructure"
      project = "azure"
    }
  }
}

provider "azurerm" {
  features {}
}