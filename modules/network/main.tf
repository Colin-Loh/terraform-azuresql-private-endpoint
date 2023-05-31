resource "azurerm_virtual_network" "this" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  address_space       = var.virtual_network_address_space
}

resource "azurerm_subnet" "service" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.cidr

  //Configuring regional Vnet integration using the App Service Networking page delegates the subnet to Microsoft.Web automatically.
  dynamic "delegation" {
    for_each = each.value.service_delegation == true ? [1] : []
    
    content {
        name = "test-delegation"

        service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
    }
  }
}

resource "azurerm_private_dns_zone" "this" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_endpoint" "this" {
  name                = var.private_endpoint_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  subnet_id           = azurerm_subnet.service["PrivateLinkSubnet"].id

  private_service_connection {
    name = "sqlprivatelink"
    is_manual_connection = "false"
    private_connection_resource_id = var.sql_server_id
    subresource_names = ["sqlServer"] //why is target sub-resource -> "sqlServer"?
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = var.private_dns_zone_virtual_network_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}


