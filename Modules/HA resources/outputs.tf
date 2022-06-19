output "resource-group-names" {
  value = [azurerm_resource_group.RES-GRPS[0].name, azurerm_resource_group.RES-GRPS[1].name]
}

output "locations" {
  value = [azurerm_resource_group.RES-GRPS[0].location, azurerm_resource_group.RES-GRPS[1].location]
}