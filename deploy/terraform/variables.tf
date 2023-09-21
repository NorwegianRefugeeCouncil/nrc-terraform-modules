variable "app_name"{
    description = "Name of the Application being deployed"
    type        = string
    default     = "meroecp"
}

variable "environment"{
    description = "Name of the environment to which the app is being deployed to"
    type        = string
    default     = "development"
}

variable "subscription_id"{
    description = "Subscription id of the Application account"
    type        = string
    default     = "037e21f1-ea37-43b0-b063-50c4e7d34c2a"
}

variable "location"{
    description = "Region on Azure where the application is being deployed"
    type        = string
    default     = "westeurope"
}

variable "app_service_plan_sku_name" {
    description = "SKU Name of the Application Service Plan to be deployed"
    type        = string
    default     = "B1"
  
}

variable "vnet_address_space" {
  description   = "Adress CIDR to be used for VNET"
  type          = string
  default       = "10.8.0.0/21"
}

variable "app_subnet_address_space" {
    description = "Subnet CIDR for app deployment"
    type        = string
    default     = "10.8.0.0/26"
  
}

variable "app_db_address_space" {
    description = "Subnet CIDR to deploy the DB"
    type        = string
     default     = "10.8.0.64/27"
  
}

variable "postgres_availability_zone" {
    description = "Primary Availability zone where the postgres server would be deployed on Azure"
    type = string
     default = "2"
}

variable "postgres_geo_redundant_backup_enabled" {
    description = "Whether the postgres redund backup has been enabled"
    type        = bool
     default     = true
}

variable "postgres_standby_availability_zone" {
    description = "Secondary/Standby Availability zone for postgres High Availability"
    type        = string
     default    = "3"
  
}

variable "dns_zone_name" {
  description    = "The domain name of the application"
  type           = string
   default       = "ecfp.app.nrc-dev.no"
}

variable "service_plan_sku_tier" {
    description   = "sku tier for the service plan"  
    type          = string
    default = "Basic"
}
variable "service_plan_sku_size" {
  description     = "sku size for the service plan"  
  type = string
  default = "B1"
}

# variable "container_image" {
#   description = "Container Image name"
#   type        = string
# }

# variable "container_image_tag" {
#   description = "Container Image Tag form the Build jonb"
#   type        = string
# }

variable "virtual_network_subnet_id" {
  description = "App subnet id obtained from the network module"
  type        = string
  default = "[10.8.0.0/26]"
}