
# vm 
resource "azurerm_virtual_machine" "practice_vm" {
  name                             = "${var.prefix}-vm"
  location                         = var.location
  resource_group_name              = var.rg_name
  network_interface_ids            = [var.nic_id]
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
      key_data = var.secret_value
      path     = "/home/admin_username/.ssh/authorized_keys"
    }
  }

}