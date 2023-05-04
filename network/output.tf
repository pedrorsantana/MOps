output "resource_group_name" {
  value = azurerm_resource_group.azmain.0.name
}

output "common_location" {
  value = azurerm_resource_group.azmain.0.location
}

output "network_interface_ids" {
  value = azurerm_network_interface.azmain.0.id
}