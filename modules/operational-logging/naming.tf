# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurenoopsutils_resource_name" "logging_st" {
  name          = random_id.uniqueString.hex
  resource_type = "azurerm_storage_account"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "st"])
  use_slug      = var.use_naming  
}

data "azurenoopsutils_resource_name" "laws" {
  name          = var.workload_name
  resource_type = "azurerm_log_analytics_workspace"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "laws"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}
