
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

output "postgresql_fqdn" {
  value = azurerm_postgresql_flexible_server.postgresdb.fqdn
}

output "postgresql_username" {
  value = azurerm_postgresql_flexible_server.postgresdb.administrator_login
}

output "postgresql_database_name" {
  value = azurerm_postgresql_flexible_server_database.database.name
}

output "postgresql_connection_string" {
  value = "postgresql://${azurerm_postgresql_flexible_server.postgresdb.administrator_login}:${azurerm_postgresql_flexible_server.postgresdb.administrator_password}@${azurerm_postgresql_flexible_server.postgresdb.fqdn}:5432/${azurerm_postgresql_flexible_server_database.database.name}"
}
