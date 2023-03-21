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

module "rg" {
  source = "./modules/rg"
}

module "keyvault" {
  source = "./modules/keyvault"
}

module "security_group" {
  source = "./modules/security_group"
}

module "pub_ip" {
  source = "./modules/pub_ip"
}

# vnet 
resource "azurerm_virtual_network" "practice_vnet" {
  name                = "practice_vnet"
  location            = var.location
  resource_group_name = module.rg.rg_name
  address_space       = var.address_space

}

# subnet
resource "azurerm_subnet" "practice_subnet" {
  name                 = "practice_subnet"
  resource_group_name  = module.rg.rg_name
  virtual_network_name = azurerm_virtual_network.practice_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}



# network interface
resource "azurerm_network_interface" "network_interface" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = module.rg.rg_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.practice_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = module.pub_ip.pub_ip_id

  }
}

# vm 
resource "azurerm_virtual_machine" "practice_vm" {
  name                             = "${var.prefix}-vm"
  location                         = var.location
  resource_group_name              = module.rg.rg_name
  network_interface_ids            = [azurerm_network_interface.network_interface.id]
  vm_size                          = "Standard_DS1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = module.keyvault.secret_value
      path     = "/home/admin_username/.ssh/authorized_keys"
    }
  }

}


