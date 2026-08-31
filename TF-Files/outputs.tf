output "vnet_a_id" {
  value = module.vnet_a.vnet_id
}

output "vnet_b_id" {
  value = module.vnet_b.vnet_id
}

output "vm_a_public_ip" {
  value = module.vm_a.public_ip
}

output "vm_b_public_ip" {
  value = module.vm_b.public_ip
}
