subscription_id               = "d607141a-42f1-4b1b-9701-5589e224f5cc"
resource_group_name           = "pwc-app-rg"
resource_group_location       = "UK South"
virtual_network_name          = "pwc-vnet"
virtual_network_address_space = ["10.0.0.0/16"]
subnet_name                   = "pwc-subnet"
subnet_address_prefixes       = ["10.0.0.0/24"]
pwc-aks_name                  = "pwc-aks-cluster"
dns_prefix                    = "pwc-aks"
vm_size                       = "Standard_B2s"
node_count                    = 2

