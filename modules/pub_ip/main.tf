
# public ip 
resource "azurerm_public_ip" "pub_ip1" {
  name                = "pub_ip1"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
}