# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "hub_resource_group_name" {
  description = "The name of the hub virtual network resource group"
  value       = module.mod_hub_network.hub_resource_group_name
}

output "hub_virtual_network_name" {
  description = "The name of the hub virtual network"
  value       = module.mod_hub_network.hub_virtual_network_name
}

output "hub_virtual_network" {
  value = module.mod_hub_network.hub_virtual_network_address_space
}