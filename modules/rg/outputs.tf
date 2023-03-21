output "resource_group_id" {
    description = "The ID of the resource group"
    value = azurerm_resource_group.practice_resource_group.id
}

output "rg_location" {
    description = "The location of the resource group"
    value = azurerm_resource_group.practice_resource_group.location
}

output "rg_name" {
    description = "The name of the resource group"
    value = azurerm_resource_group.practice_resource_group.name
}