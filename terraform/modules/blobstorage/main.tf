resource "azurerm_storage_account" "state_account" {
  name                     = var.storage_blob_name
  resource_group_name      = var.rg_name
  location                 = var.cloud_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "state_container" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.state_account.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "state_storage" {
  name                   = "my-awesome-content.zip"
  storage_account_name   = azurerm_storage_account.state_account.name
  storage_container_name = azurerm_storage_container.state_container.name
  type                   = "Block"
  source                 = var.absolute_path_to_a_file
}