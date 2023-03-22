output "vm_id" {
  description = "The vm id."
  value       = azurerm_virtual_machine.practice_vm.id
}

#output "computer_name" {
#  description = "The computer name."
#  value       = azurerm_virtual_machine.practice_vm.os_profile.computer_name
#}

#output "admin_username" {
#  description = "The admins username."
#  value       = azurerm_virtual_machine.practice_vm.os_profile.admin_username
#}

