variable "app_name"{
    description = "Name of the Applicaiton being deployed"
    type        = string
}

variable "environment"{
    description = "The environment to which the app is being deployed to"
    type        = string
}

variable "resource_group_name"{
    description = "Name of the resource group to be used during the deployment"
    type        = string
}

variable "location"{
    description = "location in Azure where the app is being deployed to"
    type        = string
}

variable "app_db_address_space"{
    description = "Address space for db subnet deployment"
    type        = string
}

variable "db_version"{
    description = "version of the db to be installed"
    type        = string
    default     = ""
}

variable "db_login_username"{
    description = "Admin Login username for the db"
    type        = string
    default     = ""
}

variable "postgres_sku_name"{
    description = "sku name of the db to be deployed"
    type        = string
    default     = ""
}

variable "postgres_availability_zone"{
    description = "Availability zone for the Azure DB deployment"
    type        = string
}

variable "postgres_storage_mb"{
    description = "Storage requirement for the Postgresdb"
    type        = number
}

variable "postgres_backup_retention_days"{
    description = "Rentention period of Postgres backup"
    type        = string
}

variable "postgres_geo_redundant_backup_enabled"{
    description = "Geo-redundant backup enabled of not"
    type        = string
    default = "false"
}

variable "postgres_enable_high_availability"{
    description = "When high availability"
    type        = bool
}

variable "postgres_standby_availability_zone"{
    description = "High Availability Standby Zone"
    type        = string
}

variable "azure_vnet" {
    description = "Name of the Virtual Network defined for the App Service"
    type        = string
}

variable "postgresql_database_name" {
    description = "name of the postgres db"
    type        = string
}

variable "law_id" {
  description = "Log Analytics Workspace id"
  type        = string
}

variable "vnet_id" {
    description = "id of the Virtual Network"
    type        = string
  
}