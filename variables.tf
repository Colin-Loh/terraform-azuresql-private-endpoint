variable "virtual_network_name" {
  type = string
}

variable "sql_server_name" {
  type = string
}

variable "sql_database_name" {
  type = string
}

variable "service_plan_name" {
  type = string
}

variable "web_app_name" {
  type = string
}

variable "rg_prefix" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "sku_name" {
    type = string
}

variable "os_type" {
    type = string
}

variable "sql_server_version" {
  type = string
}

variable "sql_admin_login" {
  type = string
}

variable "sql_admin_password" {
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
