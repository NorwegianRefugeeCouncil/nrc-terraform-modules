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
  resource_group_name = azurerm_resource_group.rg.name
  location        = var.location
  app_name        = var.app_name
  environment     = var.environment
  # service_plan_sku_name = var.app_service_plan_sku_name
  blob_storage_connection_string = module.my_blob_storage.connection_string
  database_connection_string = module.my_postgresdb.postgresql_connection_string
  depends_on = [ module.my_network ]
  service_plan_sku_tier = var.service_plan_sku_tier
  service_plan_sku_size = var.service_plan_sku_size
  virtual_network_subnet_id     = module.my_network.app_subnet_id
  service_plan_sku_name         = var.service_plan_sku_name
  app_port                      = var.app_port
  container_image               = var.container_image
  container_image_tag           = var.container_image_tag
  infra_container_registry_name = var.infra_container_registry_name  
  backend_host_name             = var.backend_host_name
  # service_plan_sku_tier         = var.service_plan_sku_tier
  # service_plan_sku_size         = var.service_plan_sku_size
}
  

module "my_blob_storage" {
  source                  = "./modules/blob_storage"
  resource_group_name     = azurerm_resource_group.rg.name
  storage_account_name    = "stg${var.app_name}${var.environment}"
  location                = var.location
  storage_container_name  = var.app_name
  depends_on = [ module.my_network ]
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
  postgres_geo_redundant_backup_enabled= var.postgres_geo_redundant_backup_enabled
  postgres_enable_high_availability= false
  postgres_standby_availability_zone= var.postgres_standby_availability_zone
  azure_vnet              = module.my_network.vnet_name
  postgresql_database_name= "${var.app_name}-db"
  depends_on = [ module.my_network ]
}

module "my_dns"{
  source                  = "./modules/dns"
  resource_group_name     = azurerm_resource_group.rg.name
  dns_zone_name           = var.dns_zone_name
  depends_on = [ module.my_network ]
}

module "cdn_frontdoor" {
  source                = "./modules/frontdoor"
  resource_group_name   = azurerm_resource_group.rg
  location              = var.location
  frontdoor_name        = "my-frontdoor"
  frontend_host_name    = "example.com"
  frontdoor_certificate_name = "my-cert"
  web_app_name          = "my-web-app"
  app_service_plan_id   = module.my_app.app_service_plan_id
  container_image       = "my-container-image:latest"
}


resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  retention_in_days   = 30
}
