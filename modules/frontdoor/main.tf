resource "azurerm_cdn_frontdoor_custom_domain" "backend" {
  name                     = "backend"
  cdn_frontdoor_profile_id = var.frontfoor_profile_id
  dns_zone_id              = var.dns_zone_id
  host_name                = var.backend_host_name

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}


resource "azurerm_cdn_frontdoor_custom_domain_association" "backend" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.backend.id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.backend.id]
}

resource "azurerm_cdn_frontdoor_endpoint" "backend" {
  name                     = "backend-${random_id.app_id.hex}"
  cdn_frontdoor_profile_id = var.frontfoor_profile_id
}

resource "azurerm_cdn_frontdoor_origin" "backend" {
  name                           = "backend"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.backend.id
  enabled                        = true
  certificate_name_check_enabled = true
  host_name                      = azurerm_linux_web_app.app.default_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_linux_web_app.app.default_hostname
  priority                       = 1
  weight                         = 1000
}

resource "azurerm_cdn_frontdoor_origin_group" "backend" {
  name                     = "backend"
  cdn_frontdoor_profile_id = var.frontfoor_profile_id
  session_affinity_enabled = false
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }
}


resource "azurerm_cdn_frontdoor_route" "backend" {
  name                          = "fdr-${random_id.app_id.hex}"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.backend.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.backend.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.backend.id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.backend.id]
  enabled                       = true

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]

  cdn_frontdoor_custom_domain_ids = [
    azurerm_cdn_frontdoor_custom_domain.backend.id,
  ]
  link_to_default_domain = false
  cache {
    query_string_caching_behavior = "UseQueryString"
    compression_enabled           = true
    content_types_to_compress = [
      "application/eot",
      "application/font",
      "application/font-sfnt",
      "application/javascript",
      "application/json",
      "application/opentype",
      "application/otf",
      "application/pkcs7-mime",
      "application/truetype",
      "application/ttf",
      "application/vnd.ms-fontobject",
      "application/xhtml+xml",
      "application/xml",
      "application/xml+rss",
      "application/x-font-opentype",
      "application/x-font-truetype",
      "application/x-font-ttf",
      "application/x-httpd-cgi",
      "application/x-mpegurl",
      "application/x-otf",
      "application/x-perl",
      "application/x-ttf",
      "application/x-javascript",
      "font/eot",
      "font/ttf",
      "font/otf",
      "font/opentype",
      "image/svg+xml",
      "text/css",
      "text/csv",
      "text/html",
      "text/javascript",
      "text/js",
      "text/plain",
      "text/richtext",
      "text/tab-separated-values",
      "text/xml",
      "text/x-script",
      "text/x-component",
      "text/x-java-source"
    ]
  }
}

resource "azurerm_cdn_frontdoor_rule" "backend_disable_auth_cache" {
  # Required as per terraform documentation
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.backend,
    azurerm_cdn_frontdoor_origin.backend,
  ]

  name                      = "disableAuthCache"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.backend.id
  order                     = 1
  behavior_on_match         = "Continue"

  actions {
    route_configuration_override_action {
      cache_behavior = "Disabled"
    }
  }

  conditions {
    request_uri_condition {
      operator     = "BeginsWith"
      match_values = ["/.auth"]
    }
  }
}

resource "azurerm_cdn_frontdoor_rule" "backend_disable_download_compression" {
  # Required as per terraform documentation
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.backend,
    azurerm_cdn_frontdoor_origin.backend,
  ]

  name                      = "disableDownloadCompression"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.backend.id
  order                     = 2
  behavior_on_match         = "Continue"

  actions {
    route_configuration_override_action {
      compression_enabled = false
    }
  }

  conditions {
    request_uri_condition {
      operator     = "EndsWith"
      match_values = ["/download"]
    }
  }
}


resource "azurerm_cdn_frontdoor_rule_set" "backend" {
  cdn_frontdoor_profile_id = var.frontfoor_profile_id
  name                     = "backend"
}