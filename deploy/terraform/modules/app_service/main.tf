# terraform {    
#   required_providers {    
#     azurerm = {    
#       source = "hashicorp/azurerm"    
#     }    
#   }    
# } 
   
# provider "azurerm" {    
#   features {}    
# }

resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.app_name}-${var.environment}"
  location = var.location
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "asp-${var.app_name}-${var.environment}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  sku {
    tier = "Basic"
    size = "B1"
  }
  kind = "Linux"
}

resource "azurerm_app_service" "app_service" {
  name                = "as-${var.app_name}-${var.environment}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  app_service_plan_id  = azurerm_app_service_plan.app_service_plan.id

  site_config {
    always_on                  = true
    dotnet_framework_version    = "v4.0"
    scm_type                   = "None"
  }

  app_settings = {
    "WEBSITE_DOTNET_VERSION" = "v4.0" 
    "AZURE_STORAGE_CONNECTION_STRING" = var.blob_storage_connection_string
  }

 # connection_string {
   # name  = "STORAGE_CONNECTION_STRING"
    #type  = "Custom"
   # value = var.blob_storage_connection_string
  #}
}



