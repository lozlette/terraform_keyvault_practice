
# vnet 
resource "azurerm_virtual_network" "practice_vnet" {
  name                = "practice_vnet"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.address_space

}

# subnet
resource "azurerm_subnet" "practice_subnet" {
  name                 = "practice_subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.practice_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# network interface
resource "azurerm_network_interface" "network_interface" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.practice_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.pub_ip_id

  }
}