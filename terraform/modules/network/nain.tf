## This network contain one public subnet

# =============== Virtual Network ===============
resource "azurerm_virtual_network" "weight_tracker_VNet" {
  name                = var.virtual_network_name
  resource_group_name = var.rg_name
  location            = var.cloud_location
  address_space       = var.virtual_network_CIDR
}

# =============== Subnet Public ===============
resource "azurerm_subnet" "public" {
  name                 = var.public_subnet_name
  address_prefixes     = var.public_subnet_CIDR
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.weight_tracker_VNet.name
}
# =============== NSG for web ===============
resource "azurerm_network_security_group" "public_Access" {
  name                = var.public_NSG_name
  location            = var.cloud_location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "port_8080"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "port_22"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# =============== Subnet Public NSG association ===============

resource "azurerm_subnet_network_security_group_association" "to_public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.public_Access.id
}

# =============== Public IP ===============
resource "azurerm_public_ip" "to_front_lb" {
  name                = var.public_ip_to_front_LB_name
  location            = var.cloud_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "to_web" {
  count               = var.instance_number
  name                = "web-pub-ip-${count.index}"
  location            = var.cloud_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
}
# =============== Availabilty Set ===============
resource "azurerm_availability_set" "website" {
  name                         = var.ava_set_name
  location                     = var.cloud_location
  resource_group_name          = var.rg_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 3

  tags = var.instances_tags
}

# =============== NIC web VMs ===============
resource "azurerm_network_interface" "web_server" {
  count               = var.instance_number
  name                = "VM_NIC_${count.index}"
  location            = var.cloud_location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "internal_${count.index}"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.to_web[count.index].id
  }
}
# =============== Load balancer ===============
resource "azurerm_lb" "frontend" {
  name                = "TestLoadBalancer"
  location            = var.cloud_location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.to_front_lb.id

  }
}


# =============== backend poolfor LB ===============
resource "azurerm_lb_backend_address_pool" "for_websits" {
  loadbalancer_id = azurerm_lb.frontend.id
  name            = "BackEndAddressPool"
}

# =============== LB rule ===============
resource "azurerm_lb_rule" "port_8080" {
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.frontend.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.for_websits.id
  probe_id = azurerm_lb_probe.web_8080.id
}
resource "azurerm_lb_rule" "port_22" {
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.frontend.id
  name                           = "SSH"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.for_websits.id
  probe_id = azurerm_lb_probe.ssh_22.id
}

# by connecting the NICs VMs we associate the VM to the backend pool
resource "azurerm_network_interface_backend_address_pool_association" "web_vms" {
  count                   = var.instance_number
  network_interface_id    = azurerm_network_interface.web_server[count.index].id
  #ip_configuration_name   = "internal_${count.index}"
  ip_configuration_name   = azurerm_network_interface.web_server[count.index].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.for_websits.id
  depends_on = [
    azurerm_network_interface.web_server
  ]
}

# =============== health probe ===============
resource "azurerm_lb_probe" "ssh_22" {
  resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.frontend.id
  name                = "ssh-running-probe"
  port                = 22
}
resource "azurerm_lb_probe" "web_8080" {
  resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.frontend.id
  name                = "entree-running-probe"
  port                = 8080
}