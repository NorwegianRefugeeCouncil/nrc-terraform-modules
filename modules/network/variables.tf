variable "app_name" {
  type        = string
  description = "Name of the Application being deployed"
}

variable "environment" {
  type        = string
  description = "Name of the Environment, the app is being deployed"
}
variable "resource_group_name" {
  type = string
  description = "Resource group name of the application and the environment in Azure"
}

variable "location" {
  type = string
  description = "Location in Azure"
}

variable "vnet_address_space" {
    type = string
    description = "cidr for the vnet"
  
}

variable "app_subnet_address_space" {
    type = string
    description = "cidr for the app subnet"
  
}
variable "db_name" {
  type        = string
  description = "Name of the DB being deployed"
}

variable "app_db_address_space" {
    type = string
    description = "cidr for the db subnet"
  
}