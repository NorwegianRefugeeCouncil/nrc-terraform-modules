output "vnet_id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "app_subnet_id" {
  description = "The ID of the App Service subnet."
  value       = azurerm_subnet.app_subnet.id
}


output "Network_sg_gp_id" {
  description = "The ID of the Network security group."
  value       = azurerm_network_security_group.app-nw-sg.id
}


output "vnet_name" {
  description = "Name of the Vnet"
  value       = azurerm_virtual_network.vnet.name
  
}

output "app_subnet_name" {
  description = "Name of the Subnet"
  value = azurerm_subnet.app_subnet.name
  
}