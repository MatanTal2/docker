variable "postgresql_user_name" {
  type = string
}
variable "postgresql_admin_pass" {
  type = string
}
variable "postgreseql_version" {
  type = string
  default = "11"
}
variable "postgresql_database_name" {
  type = string
}
variable "cloud_location" {
  type = string
}
variable "postgresql_server_name" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "start_ip_addr" {
  type = string
}
variable "end_ip_addr" {
  type = string
}