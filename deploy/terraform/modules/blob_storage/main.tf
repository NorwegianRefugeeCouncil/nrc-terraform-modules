resource "azurerm_storage_account" "blob" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_container" "blob" {
  name                  = "mycontainer"
  storage_account_name  = azurerm_storage_account.blob.name
  container_access_type = "private"
}
