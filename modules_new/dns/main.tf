resource "azurerm_dns_zone" "dns" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}


# resource "azurerm_dns_cname_record" "app_service_dns" {
#   name                = "app"
#   zone_name           = azurerm_dns_zone.example.name
#   resource_group_name = var.resource_group_name
#   ttl                 = 300
#   records             = [azurerm_app_service.example.default_site_hostname]
# }