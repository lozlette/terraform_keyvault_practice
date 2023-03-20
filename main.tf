terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.47.0"
    }
  }
}


provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

resource "azuread_user" "ad_user" {
  user_principal_name = var.user_principal_name
  display_name        = var.display_name
}

resource "azurerm_resource_group" "practice_resource_group" {
  name     = "practice_resource_group"
  location = var.location
}

resource "azurerm_network_security_group" "practice_sg" {
  name                = "practice_sg"
  location            = azurerm_resource_group.practice_resource_group.location
  resource_group_name = azurerm_resource_group.practice_resource_group.name
}

resource "azurerm_virtual_network" "practice_vnet" {
  name                = "practice_vnet"
  location            = azurerm_resource_group.practice_resource_group.location
  resource_group_name = azurerm_resource_group.practice_resource_group.name
  address_space       = var.address_space


  subnet {
    name           = "practice_subnet"
    address_prefix = var.address_prefix
  }


}

resource "azurerm_key_vault" "practice-keyvault-01" {
  name                        = "practice-keyvault-01"
  location                    = azurerm_resource_group.practice_resource_group.location
  resource_group_name         = azurerm_resource_group.practice_resource_group.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id


  }

  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
  }
}

