output "VNet_name" {
  value = azurerm_virtual_network.weight_tracker_VNet.name
}
output "availabilty_set_id" {
  value       = azurerm_availability_set.website.id
  description = "the availabilty id"
}
output "nic_id" {
  value = azurerm_network_interface.web_server[*].id
}
output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.for_websits.id
}
output "public_ip_LB_name" {
  value = azurerm_public_ip.to_front_lb.name
}