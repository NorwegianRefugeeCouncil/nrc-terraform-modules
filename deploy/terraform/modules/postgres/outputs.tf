
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

output "postgresql_connection_string" {
  value = azurerm_postgresql_flexible_server.postgresdb.postgresql_connection_string.0
}