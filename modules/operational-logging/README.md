# Azure NoOps Operational Logging Terraform Module

This module deploys a logging rg to the operations spoke network using the [Microsoft recommended Hub-Spoke network topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke). Usually, only one hub in each region with multiple spokes and each of them can also be in separate subscriptions.

## Module Usage

```hcl
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_operational_logging" {
  source  = "azurenoops/overlays-hubspoke/azurerm/modules/operational-logging"
  version = "~> 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  location           = "usgovvirginia"
  deploy_environment = "dev"
  org_name           = "anoa"
  environment        = "usgovernment"
  workload_name      = "ops-core-logging"

  #############################
  ## Logging Configuration  ###
  #############################

  # (Optional) Enable Azure Sentinel
  enable_sentinel = true

  # (Required) To enable Azure Monitoring
  # Sku Name - Possible values are PerGB2018 and Free
  # Log Retention in days - Possible values range between 30 and 730
  log_analytics_workspace_sku          = "PerGB2018"
  log_analytics_logs_retention_in_days = 30

  ################################
  ## Defender Configuration    ###
  ################################

  # Enable Security Center API Setting
  enable_security_center_setting = false
  security_center_setting_name   = "MCAS"

  # Enable auto provision of log analytics agents on VM's if they doesn't exist. 
  enable_security_center_auto_provisioning = "Off"

  # Subscription Security Center contacts
  # One or more email addresses seperated by commas not supported by Azure proivider currently
  security_center_contacts = {
    email               = "johe.doe@microsoft.com" # must be a valid email address
    phone               = "5555555555"             # Optional
    alert_notifications = true
    alerts_to_admins    = true
  }

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {} # Tags to be applied to all resources
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 1.0.0 |
| <a name="requirement_azurenoopsutils"></a> [azurenoopsutils](#requirement\_azurenoopsutils) | ~> 1.0.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurenoopsutils"></a> [azurenoopsutils](#provider\_azurenoopsutils) | ~> 1.0.4 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.22 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mod_azregions"></a> [mod\_azregions](#module\_mod\_azregions) | azurenoops/overlays-azregions-lookup/azurerm | ~> 1.0.0 |
| <a name="module_mod_logging_rg"></a> [mod\_logging\_rg](#module\_mod\_logging\_rg) | azurenoops/overlays-resource-group/azurerm | ~> 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_solution.loganalytics_sentinel](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.loganalytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_management_lock.laws_resource_group_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.sa_resource_group_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_monitor_private_link_scope.global_pls](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_private_link_scope) | resource |
| [azurerm_monitor_private_link_scoped_service.laws_pls](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_private_link_scoped_service) | resource |
| [azurerm_private_endpoint.subnet_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_security_center_auto_provisioning.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_auto_provisioning) | resource |
| [azurerm_security_center_contact.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_contact) | resource |
| [azurerm_security_center_setting.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_setting) | resource |
| [azurerm_security_center_subscription_pricing.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_subscription_pricing) | resource |
| [azurerm_security_center_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_workspace) | resource |
| [azurerm_storage_account.loganalytics_sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [random_id.uniqueString](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [azurenoopsutils_resource_name.laws](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.logging_st](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_log_analytics_workspace.logws](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_resource_group.logging_rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_tags"></a> [add\_tags](#input\_add\_tags) | Add extra tags | `map(string)` | `{}` | no |
| <a name="input_create_hub_resource_group"></a> [create\_hub\_resource\_group](#input\_create\_hub\_resource\_group) | Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is true. | `bool` | `true` | no |
| <a name="input_create_logging_resource_group"></a> [create\_logging\_resource\_group](#input\_create\_logging\_resource\_group) | Controls if the logging resource group should be created. If set to false, the resource group name must be provided. Default is true. | `bool` | `true` | no |
| <a name="input_create_private_endpoint"></a> [create\_private\_endpoint](#input\_create\_private\_endpoint) | Controls if the private endpoint should be created. If set to false, the private endpoint name must be provided. Default is true. | `bool` | `true` | no |
| <a name="input_custom_logging_resource_group_name"></a> [custom\_logging\_resource\_group\_name](#input\_custom\_logging\_resource\_group\_name) | The name of the logging resource group to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | Option to enable or disable default tags | `bool` | `true` | no |
| <a name="input_deploy_environment"></a> [deploy\_environment](#input\_deploy\_environment) | The environment to deploy. It defaults to dev. | `string` | `"dev"` | no |
| <a name="input_enable_defender_for_cloud"></a> [enable\_defender\_for\_cloud](#input\_enable\_defender\_for\_cloud) | Enables Azure Defender for Cloud. Default is true. | `bool` | `true` | no |
| <a name="input_enable_monitoring_private_endpoints"></a> [enable\_monitoring\_private\_endpoints](#input\_enable\_monitoring\_private\_endpoints) | Enables private endpoints for monitoring resources. Default is true. | `bool` | `true` | no |
| <a name="input_enable_resource_locks"></a> [enable\_resource\_locks](#input\_enable\_resource\_locks) | (Optional) Enable resource locks | `bool` | `false` | no |
| <a name="input_enable_security_center_auto_provisioning"></a> [enable\_security\_center\_auto\_provisioning](#input\_enable\_security\_center\_auto\_provisioning) | Should the security agent be automatically provisioned on Virtual Machines in this subscription? | `string` | `"Off"` | no |
| <a name="input_enable_security_center_setting"></a> [enable\_security\_center\_setting](#input\_enable\_security\_center\_setting) | Boolean flag to enable/disable data access | `bool` | `false` | no |
| <a name="input_enable_sentinel"></a> [enable\_sentinel](#input\_enable\_sentinel) | Enables an Azure Sentinel Log Analytics Workspace Solution | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The Terraform backend environment e.g. public or usgovernment | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | n/a | yes |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | (Optional) id locks are enabled, Specifies the Level to be used for this Lock. | `string` | `"CanNotDelete"` | no |
| <a name="input_log_analytics_logs_retention_in_days"></a> [log\_analytics\_logs\_retention\_in\_days](#input\_log\_analytics\_logs\_retention\_in\_days) | The number of days to retain logs for. Possible values are between 30 and 730. Default is 30. | `number` | `null` | no |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | The SKU of the Log Analytics Workspace. Possible values are PerGB2018 and Free. Default is PerGB2018. | `string` | `null` | no |
| <a name="input_metadata_host"></a> [metadata\_host](#input\_metadata\_host) | The metadata host for the Azure Cloud e.g. management.azure.com or management.usgovcloudapi.net. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Optional prefix for the generated name | `string` | `""` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Optional suffix for the generated name | `string` | `""` | no |
| <a name="input_ops_logging_law_custom_name"></a> [ops\_logging\_law\_custom\_name](#input\_ops\_logging\_law\_custom\_name) | The name of the custom operational logging laws workspace to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_ops_logging_sa_custom_name"></a> [ops\_logging\_sa\_custom\_name](#input\_ops\_logging\_sa\_custom\_name) | The name of the custom operational logging storage account to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | A name for the organization. It defaults to anoa. | `string` | `"anoa"` | no |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | The subnet id where the private endpoint will be created. | `string` | n/a | yes |
| <a name="input_scope_resource_id"></a> [scope\_resource\_id](#input\_scope\_resource\_id) | The scope of VMs to send their security data to the desired workspace, unless overridden by a setting with more specific scope | `any` | `null` | no |
| <a name="input_security_center_contacts"></a> [security\_center\_contacts](#input\_security\_center\_contacts) | Manages the subscription's Security Center Contact | `map(string)` | `{}` | no |
| <a name="input_security_center_setting_name"></a> [security\_center\_setting\_name](#input\_security\_center\_setting\_name) | The setting to manage. Possible values are `MCAS` and `WDAT` | `string` | `"MCAS"` | no |
| <a name="input_security_center_subscription_pricing"></a> [security\_center\_subscription\_pricing](#input\_security\_center\_subscription\_pricing) | The pricing tier to use. Possible values are Free and Standard | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_use_location_short_name"></a> [use\_location\_short\_name](#input\_use\_location\_short\_name) | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| <a name="input_use_naming"></a> [use\_naming](#input\_use\_naming) | Use the Azure CAF naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | A name for the workload. It defaults to ops-logging-core. | `string` | `"hub-core"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->