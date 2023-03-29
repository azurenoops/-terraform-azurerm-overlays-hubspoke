# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.22"
    }
    azurenoopsutils = {
      source  = "azurenoops/azurenoopsutils"
      version = "~> 1.0.4"
    }
  }
}

provider "azurerm" {  
  environment     = "usgovernment"
  metadata_host   = "management.usgovcloudapi.net"
  subscription_id = "<<subscription_id>>"

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "hub"
  environment     = "usgovernment"
  metadata_host   = "management.usgovcloudapi.net"
  subscription_id = "<<subscription_id>>"

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "ops"
  environment     = "usgovernment"
  metadata_host   = "management.usgovcloudapi.net"
  subscription_id = "<<subscription_id>>"

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "svcs"
  environment     = "usgovernment"
  metadata_host   = "management.usgovcloudapi.net"
  subscription_id = "<<subscription_id>>"

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "id"
  environment     = "usgovernment"
  metadata_host   = "management.usgovcloudapi.net"
  subscription_id = "<<subscription_id>>"

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}
