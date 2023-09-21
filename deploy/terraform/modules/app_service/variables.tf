variable "subscription_id" {
  description = "Name of the Subscription id"
  type    = string
  default = ""
}

variable "location" {
  description = "Location where the app_service is deployed"
  type    = string
  default = ""
}

variable "resource_group_name" {
  description = "Resource Group name where the app is to be deployed"
  type        = string
}

variable "app_name" {
  description = "Name of the App Service"
}

variable "environment" {
  description = "Environment of the App"
}

variable "service_plan_sku_tier" {
  description = "sku tier for the service plan"  
}
variable "service_plan_sku_size" {
  description = "sku size for the service plan"  
}

variable "blob_storage_connection_string" {
  description = "blob storage connection string"
}

variable "database_connection_string" {
  description = "blob storage connection string"
}

variable "virtual_network_subnet_id" {
  description = "App subnet id obtained from the network module"
  type        = string
}

# variable "container_image" {
#   description = "Container Image name"
#   type        = string
# }

# variable "container_image_tag" {
#   description = "Container Image Tag form the Build jonb"
#   type        = string
# }