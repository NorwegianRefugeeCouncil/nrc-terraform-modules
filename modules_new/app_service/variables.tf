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

variable "infra_container_registry_name"{
  description = "Then name of the Container Registry used to store the images"
  type        = string 
}

variable "container_image" {
  description = "Container Image name"
  type        = string
}

variable "container_image_tag" {
  description = "Container Image Tag form the Build jonb"
  type        = string
}

variable "service_plan_sku_name" {
  description = "sku name of the Service PLan type"
  type        = string
  
}

variable "app_port" {
  description = "The publicly accessible port of the application. By default, App Service assumes your custom container is listening on port 80. If your container listens to a different port, set the app_port to the appropriate value"
  type        = string 
}

# variable "jwt_global_admin_group" {
#   type        = string
#   description = <<
# The name of the global admin group.

# The global admin group is used to grant global admin access to the application.
# When users authenticate to the application, the application will check if the
# user is a member of the global admin group. If yes, the user will be granted
# global admin access to the application.
# }

# variable "oidc_client_id" {
#   type        = string
#   description = "The client ID of the OIDC application."

# The OIDC application is used to authenticate users to the app service.
# The OIDC application must be created beforehand.
# }

# variable "oidc_client_secret" {
#   type        = string
#   description ="The client secret of the OIDC application

# The OIDC application is used to authenticate users to the app service.
# The OIDC application must be created beforehand.
# }

# variable "oidc_well_known_url" {
#   type        = string
#   description = <<EOF
# The well-known URL of the OIDC issuer.

# The url is usually in the form of
# https://<issuer>/.well-known/openid-configuration
# EOF

# }

# variable "oidc_issuer_url" {
#   type        = string
#   description = <<EOF
# The URL of the OIDC issuer.
# EOF
# }

# variable "jwt_can_read_group" {
#   type        = string
#   description = "The name of the can read group."
# }

# variable "jwt_can_write_group" {
#   type        = string
#   description = "The name of the can write group."
# }


variable "log_level" {
  type        = string
  default     = "info"
  description = <<EOF
The log level of the application.
EOF
  validation {
    condition     = contains(["debug", "info", "warn", "error"], var.log_level)
    error_message = "The log level must be one of \"debug\", \"info\", \"warn\", or \"error\"."
  }
}

variable "backend_host_name" {
  type        = string
  description = "The hostname of the backend."
}

variable "infra_resource_group_name" {
  
  type = string
  description = "resource group of the infrastructure resources"
}