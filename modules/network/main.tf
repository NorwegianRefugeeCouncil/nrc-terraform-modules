resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]
}


resource "azurerm_subnet" "app_subnet" {
  name                 = "subnet-${var.app_name}-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.app_subnet_address_space]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.DbforPostgreSQL"]
  delegation {
    name = "appService"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}


resource "azurerm_network_security_group" "app-nw-sg" {
  name                = "${var.app_name}-${var.environment}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_subnet_network_security_group_association" "app_sg_an" {
  subnet_id                 = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.app-nw-sg.id 
}


resource "azurerm_private_dns_zone" "default" {
  name                = "${var.app_name}-${var.environment}-pdz.postgres.database.azure.com"
  resource_group_name = var.resource_group_name

  # depends_on = [azurerm_subnet_network_security_group_association.azurerm_network_security_group.app-nw-sg]
}

resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "${var.app_name}-${var.environment}-pdzvnetlink.com"
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = var.resource_group_name
}
