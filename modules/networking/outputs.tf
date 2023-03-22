output "nic_id" {
  description = "NIC ID"
  value       = azurerm_network_interface.network_interface.id
}

output "address_prefixes" {
  description = "Address prefixes"
  value       = azurerm_subnet.practice_subnet.address_prefixes
}

output "virtual_network_subnet_ids" {
  description = "virtual network subnet ids"
  value       = azurerm_subnet.practice_subnet.id
}

