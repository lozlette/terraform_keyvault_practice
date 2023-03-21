output "kv_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.practice-keyvault-01.id
}

output "secret_id" {
  description = "ID of the secret"
  value       = azurerm_key_vault_secret.vmpubkey1.id
}

output "secret_value" {
  description = "The contents of the secret"
  value       = data.local_file.key.content
  sensitive   = true
}