terraform {
  required_providers {
     random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  }

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


resource "azurerm_private_dns_zone" "db_dns_zone" {
  name                = "${var.app_name}-${var.environment}-pdz.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
#   depends_on = [azurerm_subnet_network_security_group_association.azurerm_network_security_group.app-nw-sg]
}



resource "random_password" "postgres_admin_password" {
  length  = 128
  special = false
}

resource "azurerm_postgresql_flexible_server" "postgresdb" {
  name                   = "${var.app_name}-${var.environment}-postgrres-server"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.db_version
  delegated_subnet_id    = azurerm_subnet.db_subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.db_dns_zone.id
  administrator_login    = var.db_login_username
  administrator_password = random_password.postgres_admin_password.result
  zone                   = var.postgres_availability_zone
  storage_mb             = var.postgres_storage_mb
  sku_name               = var.postgres_sku_name
  backup_retention_days  = var.postgres_backup_retention_days
  # geo_redundant_backup_enabled = var.postgres_geo_redundant_backup_enabled
  # dynamic "high_availability" {
  #   for_each = var.postgres_enable_high_availability ? [var.postgres_standby_availability_zone] : []
  #   content {
  #     mode                      = "ZoneRedundant"
  #     standby_availability_zone = high_availability.value
  #   }
  

  lifecycle {
    ignore_changes = [
      administrator_password,
      zone,
      # high_availability.0.standby_availability_zone,
    ]
  }
} 

resource "azurerm_postgresql_flexible_server_configuration" "extensions" {
  # provider  = azurerm.runtime
  server_id = azurerm_postgresql_flexible_server.postgresdb.id
  name      = "azure.extensions"
  value     = "uuid-ossp"
}