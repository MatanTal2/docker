# =============== Resource group ===============
# The Production resource group at azure cloud
resource "azurerm_resource_group" "production" {
  name     = "docker_production"
  location = "westeurope"
}

module "net" {
  source = "../modules/network"
  instance_number = 2
  instances_tags = var.instances_tags
  # VNet
  virtual_network_name = "docker_production"
  rg_name              = azurerm_resource_group.production.name
  cloud_location       = azurerm_resource_group.production.location
  virtual_network_CIDR = var.virtual_network_CIDR

  # public subnet
  public_subnet_name = var.public_subnet_name
  public_subnet_CIDR = var.public_subnet_CIDR

  # NSG public
  public_NSG_name = var.public_NSG_name

  # publiic IP load balancer
  public_ip_to_front_LB_name = var.public_ip_to_front_LB_name

  # availabilty set
  ava_set_name = var.ava_set_name

}
# create the virtual machine
module "prod_vm" {
  source                = "../modules/vm"
  # hard coded count - change for variable for more flexabilty 
  count                 = 2
  vm_name               = "prod-vm-${count.index}"
  rg_name               = azurerm_resource_group.production.name
  cloud_location        = azurerm_resource_group.production.location
  vm_size               = "Standard_B2s"
  user_name             = "${var.user_name}"
  admin_pass            = var.admin_password
  nic_id                = [element(module.net.nic_id, count.index)]
  availability_id       = module.net.availabilty_set_id

}

# module "blob" {
#   source = "../modules/blobstorage"

#   storage_blob_name = "staging_state"
#   rg_name = azurerm_resource_group.production.name
#   cloud_location = var.cloud_location
#   absolute_path_to_a_file = ""  
  
# }

# ====== create postgresql database for web app =========

module "postgres" {
  source = "../modules/postgresql"
  

  rg_name = azurerm_resource_group.production.name
  cloud_location = var.cloud_location
  postgresql_server_name = "prodd"
  
  postgresql_database_name = "weightTracker"
  postgreseql_version = var.version_postgres
  postgresql_admin_pass = var.sql_admin_pass
  postgresql_user_name = var.sql_user_name


  start_ip_addr = data.azurerm_public_ip.public_ip_LB.ip_address
  end_ip_addr = data.azurerm_public_ip.public_ip_LB.ip_address

  depends_on = [
    module.net, azurerm_resource_group.production
  ]
}


data "azurerm_public_ip" "public_ip_LB" {
  resource_group_name = azurerm_resource_group.production.name
  name = module.net.public_ip_LB_name
  depends_on = [
    module.net
  ]
}