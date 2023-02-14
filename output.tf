# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "hub_resource_group_name" {
  description = "The name of the hub virtual network resource group"
  value       = module.mod_hub_network.hub_resource_group_name
}

output "hub_virtual_network_id" {
  description = "The ID of the hub virtual network"
  value       = module.mod_hub_network.hub_virtual_network_id
}

output "hub_virtual_network_name" {
  description = "The name of the hub virtual network"
  value       = module.mod_hub_network.hub_virtual_network_name
}

output "hub_virtual_network" {
  description = "The hub virtual network address space"
  value = module.mod_hub_network.hub_virtual_network_address_space
}

output "firewall_private_ip" {
  description = "The ID of the hub firewall private IP"
  value       = module.mod_hub_network.firewall_private_ip
}

output "firewall_public_ip" {
  description = "The ID of the hub firewall public IP"
  value       = module.mod_hub_network.firewall_public_ip
}
