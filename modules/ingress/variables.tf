variable "app_name"{
    description = "Application/Product Name"
    type = string
}
variable "environment" {
  description = "Deployment Environment"
  type = string
}
variable "resource_group_name" {
  description = "Resource Group Name"
  type = string
}
variable "frontdoor_sku_name" {
    description = "Frontdoor Sku name"
    type = string
}

variable "location" {
    description = "location"
    type = string
  
}