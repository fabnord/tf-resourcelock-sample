terraform {
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sample_rg" {
  name     = "sa-sample-rg"
  location = "eastus"
}

resource "random_string" "random" {
  length  = 16
  min_lower = 16
  special = false
}

resource "azurerm_storage_account" "sample_sa" {
  name                     = "sa${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.sample_rg.name
  location                 = azurerm_resource_group.sample_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_management_lock" "samplesa" {
  name       = azurerm_storage_account.sample_sa.name
  scope      = azurerm_storage_account.sample_sa.id
  lock_level = "CanNotDelete"
  notes      = "Protect storage account from accidential deletion."
}