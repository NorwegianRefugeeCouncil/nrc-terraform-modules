variable "app_name"{
    description = "App Name for Deployment"
    type        = string
}

variable "environment"{
    description = "Deployment Environment"
    type        = string
}
variable "resource_group_name"{
    description = "Resource Group Name where app is to be deployed"
    type        = string
}
variable "location" {
    description = "location of the resource group"
    type        = string
}

variable "law_sku" {
    description = "Sku used for the Log Analytics workspace"
    type        = string  
}