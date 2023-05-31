resource "azurerm_resource_group" "this" {
  name     = "${var.rg_prefix}-rg"
  location = var.rg_location
}

module "app" {
  source = "./modules/app"
  service_plan_name = var.service_plan_name
  web_app_name = var.web_app_name
  resource_group_name = azurerm_resource_group.this.name
  resource_group_location = azurerm_resource_group.this.location
  subnet_service_id = module.network.subnet_service.id
  sku_name = var.sku_name
  os_type = var.os_type
  
}

module "sql" {
  source = "./modules/sql"
  sql_server_name = var.sql_server_name
  sql_database_name = var.sql_database_name
  resource_group_location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sql_server_version = var.sql_server_version
  sql_admin_login = var.sql_admin_login
  sql_admin_password = var.sql_admin_password
}

module "network" {
  source = "./modules/network"
  resource_group_location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name = var.virtual_network_name
  sql_server_id = module.sql.sql_server_id
  virtual_network_address_space = var.virtual_network_address_space
  subnets = var.subnets
  private_dns_zone_name = var.private_dns_zone_name
  private_endpoint_name = var.private_endpoint_name
  private_dns_zone_virtual_network_link_name = var.private_dns_zone_virtual_network_link_name
}

