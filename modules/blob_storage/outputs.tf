output "connection_string" {
  description = "The connection string for the Azure Blob Storage Account."
  value       = azurerm_storage_account.storage_account.id
}
