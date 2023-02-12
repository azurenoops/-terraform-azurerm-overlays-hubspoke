# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#--------------------------------------------------------------------------------------------------------
# Subnets Creation with, private link endpoint/servie network policies, service endpoints and Deligation.
#--------------------------------------------------------------------------------------------------------

resource "azurerm_subnet" "default_snet" {
  name                                          = local.spoke_snet_name
  resource_group_name                           = module.mod_spoke_rg.0.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.spoke_vnet.name
  address_prefixes                              = var.spoke_subnet_address_prefix
  service_endpoints                             = var.spoke_subnet_service_endpoints
  private_endpoint_network_policies_enabled     = var.spoke_private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.spoke_private_link_service_network_policies_enabled
}

resource "azurerm_subnet" "additional_snets" {
  for_each             = var.add_subnets
  name                 = lower(format("${var.org_name}-${module.mod_azregions.location_cli}-%s-snet", each.value.name))
  resource_group_name  = module.mod_spoke_rg.0.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = lookup(each.value, "service_endpoints", [])
  # Applicable to the subnets which used for Private link endpoints or services 
  private_endpoint_network_policies_enabled     = lookup(each.value, "private_endpoint_network_policies_enabled", null)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", null)
}
