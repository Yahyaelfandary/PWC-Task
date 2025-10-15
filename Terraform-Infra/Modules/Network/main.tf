resource "azurerm_virtual_network" "pwc-vnet" {
  name                = var.virtual_network_name
  address_space       = var.virtual_network_address_space
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  
}

resource "azurerm_subnet" "pwc-subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.pwc-vnet.name
  address_prefixes     = var.subnet_address_prefixes

  delegation { 
    name = "aks-delegation"
    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}