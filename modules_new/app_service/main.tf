resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "asp-${var.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  # sku_name            = var.service_plan_sku_name

  sku {
    tier = var.service_plan_sku_tier
    size = var.service_plan_sku_size
  }
  kind = "Linux"
}

resource "azurerm_user_assigned_identity" "app" {
  name                = "id-${var.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

data "azurerm_container_registry" "acr" {
  name                = var.infra_container_registry_name
  resource_group_name = var.infra_resource_group_name
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_user_assigned_identity.app.principal_id
  role_definition_name = "AcrPull"
  scope                = data.azurerm_container_registry.acr.id
}




resource "azurerm_linux_web_app" "app" {
  location                  = var.location
  name                      = "${var.app_name}-${var.environment}"
  resource_group_name       = var.resource_group_name
  service_plan_id           = azurerm_app_service_plan.app_service_plan.id
  https_only                = true
  virtual_network_subnet_id = var.virtual_network_subnet_id
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }
  site_config {
    ftps_state                                    = "Disabled"
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = azurerm_user_assigned_identity.app.client_id
    remote_debugging_enabled                      = false
    websockets_enabled                            = false
    http2_enabled                                 = true
    health_check_path = "/healthz"
    health_check_eviction_time_in_min = 10
    application_stack {
      docker_image     = var.container_image
      docker_image_tag = var.container_image_tag
    }
    cors {
      allowed_origins     = []
      support_credentials = false
    }
    app_command_line = "serve"
    # ip_restriction {
    #   service_tag = "AzureFrontDoor.Backend"
    #   headers {
    #     x_azure_fdid = [azurerm_cdn_frontdoor_profile.fd.resource_guid]
    #   }
    #   name = "Only Allow Azure Front Door"
    # }
  }
  app_settings = {
    # See https://learn.microsoft.com/en-us/azure/app-service/configure-custom-container?pivots=container-linux#configure-port-number
    WEBSITES_PORT              = var.app_port
    # oidc_AUTHENTICATION_SECRET = var.oidc_client_secret
    # CORE_DB_DSN                = "postgres://${random_pet.postgres_admin_username.id}:${random_password.postgres_admin_password.result}@${azurerm_postgresql_flexible_server.postgres.fqdn}/${azurerm_postgresql_flexible_server_database.db.name}?sslmode=require"
    CORE_DB_DRIVER             = "postgres"
    CORE_LISTEN_ADDRESS        = "0.0.0.0:${var.port}"
    # See https://learn.microsoft.com/en-us/azure/app-service/configure-authentication-customize-sign-in-out?source=recommendations#sign-out-of-a-session
    # CORE_JWT_GLOBAL_ADMIN_GROUP     = var.jwt_global_admin_group
    # CORE_JWT_CAN_READ_GROUP         = var.jwt_can_read_group
    # CORE_JWT_CAN_WRITE_GROUP        = var.jwt_can_write_group
    # CORE_ID_TOKEN_HEADER_NAME       = "x-ms-token-oidc-id-token"
    # CORE_ID_TOKEN_HEADER_FORMAT     = "jwt"
    # CORE_ACCESS_TOKEN_HEADER_NAME   = "x-ms-token-oidc-access-token"
    # CORE_ACCESS_TOKEN_HEADER_FORMAT = "jwt"
    DOCKER_CUSTOM_IMAGE_NAME        = "${var.container_image}:${var.container_image_tag}"
    POSTGRES_CONNECTION_STRING      = var.database_connection_string
    BLOB_STORAGE_CONNECTION_STRING  = var.blob_storage_connection_string
    # CORE_OIDC_ISSUER                = var.oidc_issuer_url
    # CORE_OAUTH_CLIENT_ID            = var.oidc_client_id
    # CORE_TOKEN_REFRESH_INTERVAL     = "15m"
    CORE_LOG_LEVEL                  = var.log_level

    # CORE_LOGIN_URL         = "https://${var.backend_host_name}/.auth/login/oidc"
    # CORE_TOKEN_REFRESH_URL = "https://${var.backend_host_name}/.auth/refresh"

    # CORE_HASH_KEY_1  = local.current_hash_key
    # CORE_BLOCK_KEY_1 = local.current_block_key
    # CORE_HASH_KEY_2  = local.old_hash_key
    # CORE_BLOCK_KEY_2 = local.old_block_key

  }
  # sticky_settings {
  #   app_setting_names = [
  #     "oidc_AUTHENTICATION_SECRET",
  #   ]
  # }
  # depends_on = [
  #   azurerm_role_assignment.acr_pull
  # ]
}

# AzureRM provider does not yet support the authsettingsv2.
# For now, we rely on the azapi provider to update the
# app service with proper oidc settings.
# resource "azapi_update_resource" "app_auth" {
#   provider    = azapi.runtime
#   type        = "Microsoft.Web/sites/config@2022-03-01"
#   resource_id = "${azurerm_linux_web_app.app.id}/config/web"
#   body = jsonencode({
#     properties = {
#       siteAuthSettingsV2 = {
#         platform = {
#           enabled        = true
#           runtimeVersion = "~1"
#         }
#         globalValidation = {
#           requireAuthentication       = true
#           unauthenticatedClientAction = "RedirectToLoginPage"
#           redirectToProvider          = "oidc"
#         }
#         identityProviders = {
#           customOpenIdConnectProviders = {
#             oidc = {
#               registration = {
#                 clientId = var.oidc_client_id
#                 clientCredential = {
#                   clientSecretSettingName = "oidc_AUTHENTICATION_SECRET"
#                 }
#                 openIdConnectConfiguration = {
#                   wellKnownOpenIdConfiguration = var.oidc_well_known_url
#                 }
#               },
#               login = {
#                 nameClaimType = "name"
#                 scopes = [
#                   "openid",
#                   "profile",
#                   "email",
#                   "groups",
#                   "offline_access",
#                 ]
#               }
#             }
#           }
#         }
#         login = {
#           tokenStore = {
#             enabled                    = true
#             tokenRefreshExtensionHours = 72
#           }
#         }
#         httpSettings = {
#           requireHttps = true
#           # https://learn.microsoft.com/en-us/azure/app-service/overview-authentication-authorization#considerations-when-using-azure-front-door
#           forwardProxy = {
#             convention = "Standard"
#           }
#         }
#       }
#     }
#   })
# }




