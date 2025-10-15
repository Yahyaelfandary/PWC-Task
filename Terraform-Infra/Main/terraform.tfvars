subscription_id               = "7fd128bd-df16-41c6-b100-16017261c3e2"
resource_group_name           = "pwc-app-rg"
resource_group_location       = "UK South"
virtual_network_name          = "pwc-vnet"
virtual_network_address_space = ["10.0.0.0/16"]
subnet_name                   = "pwc-subnet"
subnet_address_prefixes       = ["10.0.0.0/24"]
pwc-aks_name                  = "pwc-aks-cluster"
dns_prefix                    = "pwc-aks"
vm_size                       = "Standard_B2s"
node_count                    = 3

