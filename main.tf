provider "azurerm" {

}


resource "azurerm_resource_group" "practice_resource_group" {
  name     = ""
  location = ""
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
  address_space       = ["10.0.0.0/16"]


  subnet {
    name           = "practice_subnet"
    address_prefix = "10.0.1.0/24"
  }


}

resource "azurerm_key_vault" "practice_keyvault" {
  name                        = "practice_keyvault"
  location                    = azurerm_resource_group.practice_resource_group.location
  resource_group_name         = azurerm_resource_group.practice_resource_group.name
  enabled_for_disk_encryption = true
  tenant_id                   = 

  sku_name = "standard"

  access_policy {
    tenant_id = 
    object_id = 
    

  }

  network_acls {
    bypass = AzureServices
    default_action = Allow
  }
}

