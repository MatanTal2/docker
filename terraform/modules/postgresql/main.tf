resource "azurerm_postgresql_server" "wt_app" {
  name                = var.postgresql_server_name
  location            = var.cloud_location
  resource_group_name = var.rg_name

  # cheap sku
  sku_name = "B_Gen5_1"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  administrator_login          = var.postgresql_user_name
  administrator_login_password = var.postgresql_admin_pass
  version                      = var.postgreseql_version
  ssl_enforcement_enabled      = false
}

resource "azurerm_postgresql_database" "wt_app_DB" {
  name                = var.postgresql_database_name
  resource_group_name = var.rg_name
  server_name         = azurerm_postgresql_server.wt_app.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
  depends_on = [
    azurerm_postgresql_server.wt_app
  ]
}

#Create Postgres firewall rule to allow connection from load balancer to postgres
resource "azurerm_postgresql_firewall_rule" "postgres_firewall" {
  name                = "office"
  resource_group_name = var.rg_name
  server_name         = azurerm_postgresql_server.wt_app.name
  start_ip_address    = var.start_ip_addr
  end_ip_address      = var.end_ip_addr
}
