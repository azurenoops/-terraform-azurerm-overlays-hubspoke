# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "resource_group_name" {
  description = "The name of the hub virtual network resource group"
  value       = module.hub_spoke_landing_zone.hub_resource_group_name
}

output "virtual_network_name" {
  description = "The name of the hub virtual network"
  value       = module.hub_spoke_landing_zone.hub_virtual_network_name
}