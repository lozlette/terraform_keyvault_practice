output "pub_ip_address" {
  description = "public IP address"
  value       = azurerm_public_ip.pub_ip1.ip_address
}

output "pub_ip_id" {
  description = "public IP ID"
  value       = azurerm_public_ip.pub_ip1.id
}