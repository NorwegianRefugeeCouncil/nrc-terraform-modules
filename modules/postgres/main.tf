resource "azurerm_subnet" "db_subnet" {
  name                 = "subnet-db-${var.app_name}-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.azure_vnet
  address_prefixes     = [var.app_db_address_space]
  delegation {
    name = "flexiblepostgresdb"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "random_password" "postgres_admin_password" {
  length  = 128
  special = false
}

resource "azurerm_postgresql_flexible_server" "postgresdb" {
  name                   = "${var.app_name}-${var.environment}-postgres-server"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.db_version
  delegated_subnet_id    = azurerm_subnet.db_subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.postgres_dns.id
  administrator_login    = var.db_login_username
  administrator_password = random_password.postgres_admin_password.result
  # zone                   = var.postgres_availability_zone
  storage_mb             = var.postgres_storage_mb
  sku_name               = var.postgres_sku_name
  backup_retention_days  = var.postgres_backup_retention_days
  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.vnet_link
  ]
} 


resource "azurerm_postgresql_flexible_server_configuration" "extensions" {
  server_id = azurerm_postgresql_flexible_server.postgresdb.id
  name      = "azure.extensions"
  value     = "uuid-ossp"
}

resource "azurerm_postgresql_flexible_server_database" "this_database" {
  name                = var.postgresql_database_name
  server_id           = azurerm_postgresql_flexible_server.postgresdb.id
  charset             = "UTF8"
  collation           = "en_US.utf8"
}

# resource "azurerm_postgresql_firewall_rule" "example" {
#   name                = "allow-subnet-access"
#   server_name         = azurerm_postgresql_server.example.name
#   resource_group_name = azurerm_resource_group.example.name
#   start_ip_address    = "10.0.1.0"
#   end_ip_address      = "10.0.1.255"
# }

resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = "${var.app_name}-${var.environment}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = azurerm_private_dns_zone.postgres_dns.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.resource_group_name
}

resource "azurerm_monitor_diagnostic_setting" "postgres" {
  name                       = "diag-postgres-${azurerm_postgresql_flexible_server.postgresdb.name}"
  target_resource_id         = azurerm_postgresql_flexible_server.postgresdb.id
  log_analytics_workspace_id = var.law_id
  log {
    category = "PostgreSQLLogs"
  }
  metric {
    category = "AllMetrics"
  }
}
