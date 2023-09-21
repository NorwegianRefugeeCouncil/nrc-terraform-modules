
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


variable "app_name" {
  description = "Name of the App Service"
}

variable "environment" {
  description = "Environment of the App"
}

variable "service_plan_sku_name" {
  description = "sku name for the service plan"
  
}

variable "blob_storage_connection_string" {
  description = "blob storage connection string"
  
}

