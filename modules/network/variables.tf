variable "resource_group_name" {
    type = string
}

variable "resource_group_location" {
    type = string
}

variable "virtual_network_name" {
    type = string
}

variable "sql_server_id" {
    type = string
}

variable "virtual_network_address_space" {
    type = list
}

variable "subnets" {
    type = map(any)
}

variable "private_dns_zone_name" {
    type = string
}

variable "private_endpoint_name" {
    type = string
}

variable "private_dns_zone_virtual_network_link_name" {
    type = string
}