# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Local declarations
#---------------------------------
resource "random_id" "uniqueString" {
  keepers = {
    # Generate a new id each time we change resourePrefix variable
    org_prefix = var.org_name
    subid      = var.workload_name
  }
  byte_length = 8
}

locals {
  # Path: src\terraform\azresources\modules\Microsoft.Security\azureSecurityCenter\main.tf
  # Name: azureSecurityCenter
  # Description: Azure Security Center

  bundle = (var.environment == "public") ? [
    "AppServices",
    "Arm",
    "ContainerRegistry",
    "Containers",
    "CosmosDbs",
    "Dns",
    "KeyVaults",
    "KubernetesService",
    "OpenSourceRelationalDatabases",
    "SqlServers",
    "SqlServerVirtualMachines",
    "StorageAccounts",
    "VirtualMachines"
    ] : (var.environment == "usgovernment") ? [
    "Arm",
    "ContainerRegistry",
    "Containers",
    "Dns",
    "KubernetesService",
    "OpenSourceRelationalDatabases",
    "SqlServers",
    "SqlServerVirtualMachines",
    "StorageAccounts",
    "VirtualMachines"
  ] : []


  privateLinkConnectionName    = "plconn${azurerm_log_analytics_workspace.loganalytics.name}${random_id.uniqueString.hex}"
  privateLinkEndpointName      = "pl${azurerm_log_analytics_workspace.loganalytics.name}${random_id.uniqueString.hex}"
  privateLinkScopeName         = "plscope${azurerm_log_analytics_workspace.loganalytics.name}${random_id.uniqueString.hex}"
  privateLinkScopeResourceName = "plscres${azurerm_log_analytics_workspace.loganalytics.name}${random_id.uniqueString.hex}"
}
