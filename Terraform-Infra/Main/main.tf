module "Resource" {
  source = "../Modules/Resources"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "Network" {
  source                  = "../Modules/Network"
  resource_group_name     = module.Resource.resource_group_name
  resource_group_location = module.Resource.resource_group_location
  virtual_network_name    = var.virtual_network_name
  virtual_network_address_space = var.virtual_network_address_space
  subnet_name            = var.subnet_name
  subnet_address_prefixes = var.subnet_address_prefixes
}

module "AKS" {
  source                  = "../Modules/AKS"
  resource_group_name     = module.Resource.resource_group_name
  resource_group_location = module.Resource.resource_group_location
  virtual_network_name    = module.Network.virtual_network_name
  pwc-aks_name            = var.pwc-aks_name
  dns_prefix              = var.dns_prefix
  node_count              = var.node_count
  vm_size                 = var.vm_size
  
}