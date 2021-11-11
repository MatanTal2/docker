variable "instances_tags" {
  type = object({
    Owner = string
    Part  = string
  })
  description = "Tags Owner and Part tags"
}
variable "cloud_location" {
  type = string
  description = "cloud location"
}
variable "RG_staging_name" {
  type = string
  description = "staging resource group name"
  default = "docker_staging"
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
variable "private_subnet_name" {
  type        = string
  description = "private subnet name"
}
variable "private_subnet_CIDR" {
  type        = list(string)
  description = "private subnet addr prefixs"
}
# NSG
variable "public_NSG_name" {
  type        = string
  description = "Public NSG name"
}
variable "private_NSG_name" {
  type        = string
  description = "private NSG name"
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

# ================ VM values ==============
variable "user_name" {
  type = string
  description = "User name"
}
variable "admin_password" {
  type        = string
  description = "User password"
}

# disk with default values for the Virtual machine
variable "disk_caching" {
  type        = string
  description = "Disk caching"
  default = "ReadWrite"
}
variable "disk_storage_account_type" {
  type        = string
  description = "Disk storage account type"
  default = "Standard_LRS"
}

# source image reference with default values for the Virtual machine
variable "os_source_image_publisher" {
  type        = string
  description = "image publisher"
  default = "Canonical"
}
variable "os_source_image_sku" {
  type        = string
  description = "image sku"
  default = "18.04-LTS"
}
variable "os_source_image_offer" {
  type        = string
  description = "image offer"
  default = "UbuntuServer"
}
variable "os_source_image_version" {
  type        = string
  description = "image version"
  default = "latest"
}
###################################

# postgresql server
variable "sql_admin_pass" {
  type        = string
  description = "admit password for postgresql"
}
variable "sql_user_name" {
  type        = string
  description = "user name for postgresql"
}
variable "version_postgres" {
  type        = string
  description = "postgresql version"
  default = "11"
}
