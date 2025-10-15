terraform {
  backend "azurerm" {
    resource_group_name  = "pwc-app-storage"
    storage_account_name = "pwcappstorageaccount"
    container_name       = "pwc-app-container"
    key                  = "pwc-app-terraform.tfstate"
  }
}