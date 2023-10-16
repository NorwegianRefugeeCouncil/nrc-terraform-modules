resource "azurerm_postgresql_flexible_server_database" "default" {
  name      = "${var.app_name}-${var.environment}-db"
  server_id = azurerm_postgresql_flexible_server.postgresdb.id
  collation = "en_US.UTF8"
  charset   = "UTF8"
}