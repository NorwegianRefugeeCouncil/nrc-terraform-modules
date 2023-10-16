resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.law_sku
  retention_in_days   = 30
}