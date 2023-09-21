
output "azurerm_postgresql_flexible_server" {
  value = azurerm_postgresql_flexible_server.postgresdb.name
}

output "postgresql_flexible_server_database_name" {
  value = azurerm_postgresql_flexible_server_database.default
}

output "postgresql_flexible_server_admin_password" {
  sensitive = true
  value     = azurerm_postgresql_flexible_server.postgresdb.administrator_password
}