resource "azurerm_resource_group" "this" {
  name     = "learning-cloud-02-resource-group"
  location = "australiaeast"
}

resource "azurerm_service_plan" "this" {
  name                = "learning-cloud-02-service-plan"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "P1v2"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "this" {
  name                = "learning-cloud-02-web-app"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  service_plan_id     = azurerm_service_plan.this.id
  virtual_network_subnet_id = azurerm_subnet.service.id

  site_config {}
}

resource "azurerm_sql_server" "this" {
  name                         = "learning-cloud-02-sql-server"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  version                      = "12.0"
  administrator_login          = "adm1nstr4t0r"
  administrator_login_password = "thisIsDog11"
}

resource "azurerm_sql_database" "this" {
  name                = "learning-cloud-02-sql-database"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  server_name         = azurerm_sql_server.this.name
}

// TODO: Should always create resources outside of the virtual network first

resource "azurerm_virtual_network" "this" {
  name                = "learning-cloud-02-virtual-network"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "service" {
  name                 = "AppSvcSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes       = ["10.1.2.0/24"]

  //Configuring regional Vnet integration using the App Service Networking page delegates the subnet to Microsoft.Web automatically.
  delegation {
    name = "test-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "endpoint" {
  name                 = "PrivateLinkSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes       = ["10.1.1.0/24"]
}

resource "azurerm_private_dns_zone" "this" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_endpoint" "this" {
  name                = "learning-cloud-02-private-endpoint"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.endpoint.id

  private_service_connection {
    name = "sqlprivatelink"
    is_manual_connection = "false"
    private_connection_resource_id = azurerm_sql_server.this.id
    subresource_names = ["sqlServer"] //why is target sub-resource -> "sqlServer"?
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "learning-cloud-02-private-dns-zone-virtual-network-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}


