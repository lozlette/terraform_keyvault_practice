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

data "local_file" "key" {
  filename = var.key_file_path
}

# resource group
resource "azurerm_resource_group" "practice_resource_group" {
  name     = "practice_resource_group"
  location = var.location
}

# security group
resource "azurerm_network_security_group" "practice_sg" {
  name                = "practice_sg"
  location            = azurerm_resource_group.practice_resource_group.location
  resource_group_name = azurerm_resource_group.practice_resource_group.name
}

# vnet 
resource "azurerm_virtual_network" "practice_vnet" {
  name                = "practice_vnet"
  location            = azurerm_resource_group.practice_resource_group.location
  resource_group_name = azurerm_resource_group.practice_resource_group.name
  address_space       = var.address_space

}

# subnet
resource "azurerm_subnet" "practice_subnet" {
  name                 = "practice_subnet"
  resource_group_name  = azurerm_resource_group.practice_resource_group.name
  virtual_network_name = azurerm_virtual_network.practice_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# keyvault
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

    key_permissions = [
      "Create",
      "Get",
      "List"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List"
    ]
  }

  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
  }
}

# secret
resource "azurerm_key_vault_secret" "vmpubkey1" {
  name         = "vmpubkey1"
  value        = data.local_file.key.content
  key_vault_id = azurerm_key_vault.practice-keyvault-01.id
}

# network interface
resource "azurerm_network_interface" "network_interface" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.practice_resource_group.location
  resource_group_name = azurerm_resource_group.practice_resource_group.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.practice_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pub_ip1.id
    
  }
}

# vm 
resource "azurerm_virtual_machine" "practice_vm" {
  name                             = "${var.prefix}-vm"
  location                         = azurerm_resource_group.practice_resource_group.location
  resource_group_name              = azurerm_resource_group.practice_resource_group.name
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
      key_data = azurerm_key_vault_secret.vmpubkey1.value
      path     = "/home/admin_username/.ssh/authorized_keys"
    }
  }

}

# public ip 
resource "azurerm_public_ip" "pub_ip1" {
  name                = "pub_ip1"
  resource_group_name = azurerm_resource_group.practice_resource_group.name
  location            = azurerm_resource_group.practice_resource_group.location
  allocation_method   = "Static"
}
