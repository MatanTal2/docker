variable "instances_tags" {
  type = object({
    Owner = string
    Part  = string
  })
  description = "Tags Owner and Part tags"
}
# resource group
variable "rg_name" {
  type        = string
  description = "resource group name"
}
variable "cloud_location" {
  type        = string
  description = "resource location"
}
# Virtual Network variables
variable "virtual_network_CIDR" {
  type        = list(string)
  description = "virtual network address space"
}
variable "virtual_network_name" {
  type        = string
  description = "Virtual Network name"
}
# Subnets variables
variable "public_subnet_CIDR" {
  type        = list(string)
  description = "public subnet addr prefixs"
}
variable "public_subnet_name" {
  type        = string
  description = "public subnet name"
}

# NSG
variable "public_NSG_name" {
  type        = string
  description = "Public NSG name"
}

# public IP
variable "public_ip_to_front_LB_name" {
  type        = string
  description = "public IP to front load balancer"
}
# availabilty set
variable "ava_set_name" {
  type        = string
  description = "availability set name"
}
variable "instance_number" {
  type = number
  description = "The number of instance to create"
}