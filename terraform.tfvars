//resource group configuration
rg_prefix   = "sql-private-connection"
rg_location = "australiaeast"

// network configuration
virtual_network_name = "sql-private-connection-virtual-network"
virtual_network_address_space = ["10.1.0.0/16"]

// subnet configuration
subnets = {
    AppSvcSubnet = {
        cidr = ["10.1.2.0/24"]
        service_delegation = true
    }
    PrivateLinkSubnet = {
        cidr = ["10.1.1.0/24"]
        service_delegation = false
    }
}

// private dns configuration
private_dns_zone_name = "privatelink.database.windows.net"
// private endpoint configuration
private_endpoint_name = "sql-private-connection"
private_dns_zone_virtual_network_link_name = "sql-private-connection-dns-zone-virtual-network-link"

//application configuration
service_plan_name    = "sql-private-connection-service-plan"
web_app_name         = "sql-private-connection-web-app"
sku_name = "P1v2"
os_type  = "Windows"

//sql server configuration
sql_server_version = "12.0"
sql_admin_login = "adm1nstr4t0r"
sql_admin_password = "thisIsDog11"
sql_server_name      = "sql-private-connection-server"
sql_database_name    = "sql-private-connection-database"