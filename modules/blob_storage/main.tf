resource "azurerm_subnet" "storage_subnet" {
  name                 = "subnet-storage-${var.app_name}-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "stg${var.app_name}${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["${var.permitted_ip}"]
    virtual_network_subnet_ids = [azurerm_subnet.azurerm_subnet.storage_subnet.id]
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_container" "blob" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
