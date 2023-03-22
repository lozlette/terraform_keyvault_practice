# resource group
resource "azurerm_resource_group" "practice_resource_group" {
  name     = var.rg_name
  location = var.location
}
