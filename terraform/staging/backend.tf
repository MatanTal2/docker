# terraform {
#   backend "azurerm" {
#     storage_account_name = "terraformproj"
#     container_name       = "containproj"
#     key                  = "prod.terraform.tfstate"

#     # rather than defining this inline, the SAS Token can also be sourced
#     # from an Environment Variable - more information is available below.
#     sas_token = var.v_sas_token
#   }
# }
