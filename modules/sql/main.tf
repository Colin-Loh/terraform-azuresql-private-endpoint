resource "azurerm_sql_server" "this" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  version                      = var.sql_server_version
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_sql_database" "this" {
  name                = var.sql_database_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  server_name         = var.sql_server_name
}