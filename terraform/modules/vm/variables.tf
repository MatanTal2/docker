variable "rg_name" {
  type        = string
  description = "resource group name"
}
variable "cloud_location" {
  type        = string
  description = "resource location"
}

variable "vm_name" {
  type        = string
  description = "vm name"
}

variable "vm_size" {
  type        = string
  description = "virtual machine size"
}
variable "user_name" {
  type        = string
  description = "User name"
}
variable "admin_pass" {
  type        = string
  description = "User password"
}

###################################

variable "availability_id" {
  description = "availability id"
}
variable "nic_id" {
  description = "nic id"
}