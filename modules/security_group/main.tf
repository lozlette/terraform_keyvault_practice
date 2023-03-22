

# security group
resource "azurerm_network_security_group" "practice_sg" {
  name                = "practice_sg"
  location            = var.location
  resource_group_name = var.rg_name
  security_rule {
    name                       = "ssh_inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = var.pub_ip_address

  }

  security_rule {
    name                       = "ssh_outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = var.pub_ip_address
    destination_address_prefix = "*"
  }
}