resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                = "fd-${var.app_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  sku_name            = var.frontdoor_sku_name
}

resource "azurerm_web_application_firewall_policy" "backend" {
  name                = "waf${var.app_name}${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location

  policy_settings {
    file_upload_limit_in_mb     = 800
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      version = "3.2"
      type    = "OWASP"
    }
  }
}