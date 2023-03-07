# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "laws_name" {
  description = "LAWS Name"
  value       = azurerm_log_analytics_workspace.loganalytics.name
}

output "laws_rgname" {
  description = "Resource Group for Laws"
  value       = azurerm_log_analytics_workspace.loganalytics.resource_group_name
}

output "laws_resource_id" {
  description = "Resource ID for Laws"
  value       = azurerm_log_analytics_workspace.loganalytics.id
}

output "laws_storage_account_id" {
  description = "LAWS Storage Account ID"
  value       = azurerm_storage_account.loganalytics_sa.id
}

output "laws_storage_account_name" {
  description = "LAWS Storage Account Name"
  value       = azurerm_storage_account.loganalytics_sa.name
}

output "laws_storage_account_key" {
  description = "LAWS Storage Account Key"
  value       = azurerm_storage_account.loganalytics_sa.primary_access_key
}

output "laws_storage_account_rgname" {
  description = "LAWS Storage Account Resource Group Name"
  value       = azurerm_storage_account.loganalytics_sa.resource_group_name
}

output "laws_storage_account_location" {
  description = "LAWS Storage Account Location"
  value       = azurerm_storage_account.loganalytics_sa.location
}

output "laws_storage_account_tier" {
  description = "LAWS Storage Account Tier"
  value       = azurerm_storage_account.loganalytics_sa.account_tier
}
