variable "location_a" {
	description = "Location for region A"
	type        = string
	default     = "eastus"
}

variable "location_b" {
	description = "Location for region B"
	type        = string
	default     = "westus2"
}

variable "resource_group_a_name" {
	type    = string
	default = "rg-region-a"
}

variable "resource_group_b_name" {
	type    = string
	default = "rg-region-b"
}

variable "vnet_a_name" {
	type    = string
	default = "vnet-a"
}

variable "vnet_b_name" {
	type    = string
	default = "vnet-b"
}

variable "vnet_a_address_space" {
	type    = list(string)
	default = ["10.10.0.0/16"]
}

variable "vnet_b_address_space" {
	type    = list(string)
	default = ["10.20.0.0/16"]
}

variable "vnet_a_subnet_name" {
	type    = string
	default = "subnet-a"
}

variable "vnet_b_subnet_name" {
	type    = string
	default = "subnet-b"
}

variable "vnet_a_subnet_prefixes" {
	type    = list(string)
	default = ["10.10.1.0/24"]
}

variable "vnet_b_subnet_prefixes" {
	type    = list(string)
	default = ["10.20.1.0/24"]
}

variable "vm_a_name" {
	type    = string
	default = "vm-a"
}

variable "vm_b_name" {
	type    = string
	default = "vm-b"
}

variable "vm_a_size" {
	type    = string
	default = "Standard_B1s"
}

variable "vm_b_size" {
	type    = string
	default = "Standard_B1s"
}

variable "admin_username" {
	type    = string
	default = "azureuser"
}

variable "ssh_public_key" {
	description = "SSH public key for VM access"
	type        = string
}
