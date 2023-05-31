output "subnet_service" {
    value = azurerm_subnet.service["AppSvcSubnet"]
    description = " Regional network integration mounts a virtual interface in the AppSvcSubnet that the App Service web app connects to."
}

# output "virtual_network" {
#     value = azurerm_virtual_network.this
# }

# output "subnet_endpoint" {
#     value = azurerm_subnet.endpoint
# }

# output "private_dns_zone" {
#     value = azurerm_private_dns_zone.this
# }

# output "private_endpoint" {
#     value = azurerm_private_endpoint.this
# }

# output "aprivate_dns_zone_virtual_network_link" {
#     value = azurerm_private_dns_zone_virtual_network_link.this
# }