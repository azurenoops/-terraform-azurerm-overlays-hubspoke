# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Log Analytics Lock configuration - Default (required). 
#------------------------------------------------------------
resource "azurerm_management_lock" "laws_resource_group_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.ops_logging_law_name}-${var.lock_level}-lock"
  scope      = azurerm_log_analytics_workspace.loganalytics.id
  lock_level = var.lock_level
  notes      = "Log Analytics '${local.ops_logging_law_name}' is locked with '${var.lock_level}' level."
}

#------------------------------------------------------------
# Storage Account Lock configuration - Default (required). 
#------------------------------------------------------------
resource "azurerm_management_lock" "sa_resource_group_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.ops_logging_sa_name}-${var.lock_level}-lock"
  scope      = azurerm_storage_account.loganalytics_sa.id
  lock_level = var.lock_level
  notes      = "Storage Account '${local.ops_logging_sa_name}' is locked with '${var.lock_level}' level."
}
