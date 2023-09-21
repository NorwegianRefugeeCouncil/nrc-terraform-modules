terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.67.0"
    }
  }
}
  provider "azurerm" {
   features {}
 }

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "rg-${var.app_name}-${var.environment}"
}

module "my_app" {
  source              = "./modules/app_service"
  subscription_id = var.subscription_id
  location        = var.location
  app_name        = var.app_name
  environment     = var.environment
  service_plan_sku_name = var.app_service_plan_sku_name
  #app_service_plan_name = "asp-meroecp-dev"
  blob_storage_connection_string = module.my_blob_storage.connection_string
  
}

module "my_blob_storage" {
  source                  = "./modules/blob_storage"
  resource_group_name     = azurerm_resource_group.rg.name
  storage_account_name    = "stg${var.app_name}${var.environment}"
  location                = var.location
}

module "my_network" {
  source                  = "./modules/network"
  location                = var.location
  app_name                = var.app_name
  environment             = var.environment
  vnet_address_space      = var.vnet_address_space
  app_subnet_address_space= var.app_subnet_address_space
  db_name                 = var.app_name
  app_db_address_space    =  var.app_db_address_space
  resource_group_name     = azurerm_resource_group.rg.name

}

module "my_postgresdb"{
  source                  = "./modules/postgres"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = var.location
  environment             = var.environment
  app_name                = var.app_name
  app_db_address_space    = var.app_db_address_space
  postgres_availability_zone= var.postgres_availability_zone
  # postgres_geo_redundant_backup_enabled= var.postgres_geo_redundant_backup_enabled
  # postgres_enable_high_availability= false
  # postgres_standby_availability_zone= var.postgres_standby_availability_zone
  azure_vnet              = module.my_network.vnet_name
  depends_on = [ module.my_network ]
}

module "my_dns"{
  source                  = "./modules/dns"
  resource_group_name     = azurerm_resource_group.rg.name
  dns_zone_name           = var.dns_zone_name
}