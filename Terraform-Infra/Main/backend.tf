terraform {
  backend "azurerm" {
    resource_group_name  = "pwc-app-storage"
    storage_account_name = "pwcappstorageaccount2"
    container_name       = "pwc-app-container"
    key                  = "pwc-app-terraform.tfstate"
  }
}