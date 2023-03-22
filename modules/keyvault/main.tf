data "local_file" "key" {
  filename = var.key_file_path
}

# keyvault
resource "azurerm_key_vault" "practice-keyvault-01" {
  name                        = "practice-keyvault-01"
  location                    = var.location
  resource_group_name         = var.rg_name
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