variable "app_name" {
  description = "Name of the Application/Product"
  type        = string
}
variable "environment" {
  description = "Environment to which the app is being deployed to"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
  
}
variable "resource_group_name" {
  description = "The name of the Azure resource group."
  type = string
}

variable "storage_container_name" {
  description = "The name of the Azure Storage Container."
  type = string
}

variable "location" {
  description = "The Azure region where the Storage Account should be created."
  type = string
}

variable "permitted_ip" {
  description = "Ips that are allowed to access the storage account"
  type = string
  
}