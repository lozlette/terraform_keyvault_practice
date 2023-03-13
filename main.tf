provider "azurerm" {

}


resource "azurerm_resource_group" "practice_resource_group" {
  name     = ""
  location = ""
}

resource "azurerm_key_vault" "practice_keyvault" {
  name                        = "practice_keyvault"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  enabled_for_disk_encryption = true
  tenant_id                   = 

  sku_name = "standard"

  access_policy {
    tenant_id = 
    object_id = 

  }
}