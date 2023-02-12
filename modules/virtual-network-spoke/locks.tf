# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Vnet Lock configuration - Default (required). 
#------------------------------------------------------------
resource "azurerm_management_lock" "vnet_resource_group_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.spoke_vnet_name}-${var.lock_level}-lock"
  scope      = azurerm_virtual_network.spoke_vnet.id
  lock_level = var.lock_level
  notes      = "Virtual Network '${local.spoke_vnet_name}' is locked with '${var.lock_level}' level."
}

#------------------------------------------------------------
# Subnet Lock configuration - Default (required). 
#------------------------------------------------------------
resource "azurerm_management_lock" "subnet_resource_group_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.spoke_snet_name}-${var.lock_level}-lock"
  scope      = azurerm_subnet.default_snet.id
  lock_level = var.lock_level
  notes      = "Subnet '${local.spoke_snet_name}' is locked with '${var.lock_level}' level."
}

#------------------------------------------------------------
# Storage Account Lock configuration - Default (required). 
#------------------------------------------------------------
resource "azurerm_management_lock" "sa_resource_group_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.spoke_sa_name}-${var.lock_level}-lock"
  scope      = azurerm_route_table.routetable.id
  lock_level = var.lock_level
  notes      = "Storage Account '${local.spoke_sa_name}' is locked with '${var.lock_level}' level."
}
