output "profile_id" {
    value = azurerm_cdn_frontdoor_profile.fd.id
}

output "azurerm_web_application_firewall_policy" {
    value = azurerm_web_application_firewall_policy.backend.id
  
}