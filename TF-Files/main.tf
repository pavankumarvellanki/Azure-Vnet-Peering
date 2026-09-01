// Resource groups for the two regions
resource "azurerm_resource_group" "rg_a" {
  name     = var.resource_group_a_name
  location = var.location_a
}

resource "azurerm_resource_group" "rg_b" {
  name     = var.resource_group_b_name
  location = var.location_b
}

// VNet A
module "vnet_a" {
  source              = "./modules/vnet"
  name                = var.vnet_a_name
  location            = var.location_a
  resource_group_name = azurerm_resource_group.rg_a.name
  address_space       = var.vnet_a_address_space
  subnet_name         = var.vnet_a_subnet_name
  subnet_prefixes     = var.vnet_a_subnet_prefixes
}

// VNet B
module "vnet_b" {
  source              = "./modules/vnet"
  name                = var.vnet_b_name
  location            = var.location_b
  resource_group_name = azurerm_resource_group.rg_b.name
  address_space       = var.vnet_b_address_space
  subnet_name         = var.vnet_b_subnet_name
  subnet_prefixes     = var.vnet_b_subnet_prefixes
}

// VM in region A
module "vm_a" {
  source              = "./modules/vm"
  name                = var.vm_a_name
  location            = var.location_a
  resource_group_name = azurerm_resource_group.rg_a.name
  subnet_id           = module.vnet_a.subnet_id
  vm_size             = var.vm_a_size
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
}

// VM in region B
module "vm_b" {
  source              = "./modules/vm"
  name                = var.vm_b_name
  location            = var.location_b
  resource_group_name = azurerm_resource_group.rg_b.name
  subnet_id           = module.vnet_b.subnet_id
  vm_size             = var.vm_b_size
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
}

// VNet peering: A -> B
resource "azurerm_virtual_network_peering" "a_to_b" {
  name                         = "${var.vnet_a_name}-to-${var.vnet_b_name}"
  resource_group_name          = azurerm_resource_group.rg_a.name
  virtual_network_name         = var.vnet_a_name
  remote_virtual_network_id    = module.vnet_b.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

// VNet peering: B -> A
resource "azurerm_virtual_network_peering" "b_to_a" {
  name                         = "${var.vnet_b_name}-to-${var.vnet_a_name}"
  resource_group_name          = azurerm_resource_group.rg_b.name
  virtual_network_name         = var.vnet_b_name
  remote_virtual_network_id    = module.vnet_a.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
