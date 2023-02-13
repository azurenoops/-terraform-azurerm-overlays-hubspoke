# Azure NoOps Virtual Network Hub with Firewall Terraform Module

This module deploys a hub network using the [Microsoft recommended Hub-Spoke network topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke). Usually, only one hub in each region with multiple spokes and each of them can also be in separate subscriptions.

These types of resources are supported:

* [Virtual Network](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html)
* [Subnets](https://www.terraform.io/docs/providers/azurerm/r/subnet.html)
* [Subnet Service Delegation](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#delegation)
* [Virtual Network service endpoints](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#service_endpoints)
* [Private Link service/Endpoint network policies on Subnet](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#enforce_private_link_endpoint_network_policies)
* [AzureNetwork DDoS Protection Plan](https://www.terraform.io/docs/providers/azurerm/r/network_ddos_protection_plan.html)
* [Network Security Groups](https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html)
* [Azure Firewall](https://www.terraform.io/docs/providers/azurerm/r/firewall.html)
* [Azure Firewall Application Rule Collection](https://www.terraform.io/docs/providers/azurerm/r/firewall_application_rule_collection.html)
* [Azure Firewall Network Rule Collection](https://www.terraform.io/docs/providers/azurerm/r/firewall_network_rule_collection.html)
* [Azure Firewall NAT Rule Collection](https://www.terraform.io/docs/providers/azurerm/r/firewall_nat_rule_collection.html)
* [Route Table](https://www.terraform.io/docs/providers/azurerm/r/route_table.html)
* [Role Assignment for Peering](https://www.terraform.io/docs/providers/azurerm/r/role_assignment.html)
* [Storage Account for Log Archive](https://www.terraform.io/docs/providers/azurerm/r/storage_account.html)
* [Log Analytics Workspace](https://www.terraform.io/docs/providers/azurerm/r/log_analytics_workspace.html)
* [Azure Monitoring Diagnostics](https://www.terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html)
* [Network Watcher](https://www.terraform.io/docs/providers/azurerm/r/network_watcher.html)
* [Network Watcher Workflow Logs](https://www.terraform.io/docs/providers/azurerm/r/network_watcher_flow_log.html)
* [Private DNS Zone](https://www.terraform.io/docs/providers/azurerm/r/private_dns_zone.html)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
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
| <a name="module_mod_hub_rg"></a> [mod\_hub\_rg](#module\_mod\_hub\_rg) | azurenoops/overlays-resource-group/azurerm | ~> 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_bastion_host.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_firewall.fw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_firewall_policy.firewallpolicy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.app_rule_collection_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_firewall_policy_rule_collection_group.nat_rule_collection_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_firewall_policy_rule_collection_group.nw_rule_collection_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_management_lock.fw_client_subnet_resource_group_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.fw_mgt_subnet_resource_group_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.sa_resource_group_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.subnet_resource_group_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.vnet_resource_group_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_network_ddos_protection_plan.ddos](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_ddos_protection_plan) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.appgw_health_probe_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.cifs_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.deny_all_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.http_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.https_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.lb_health_probe_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.nfs_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.nsg_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.rdp_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.ssh_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.winrm_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_watcher.nwatcher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_watcher) | resource |
| [azurerm_private_dns_zone.privatelink_agentsvc_azure_automation_net](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.privatelink_blob_core_cloudapi_net](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.privatelink_monitor_azure_com](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.privatelink_ods_opinsights_azure_com](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.privatelink_oms_opinsights_azure_com](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.privateDnsZones_privatelink_blob_core_cloudapi_net_privateDnsZones_privatelink_blob_core_cloudapi_net_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.privatelink_agentsvc_azure_automation_net_privatelink_agentsvc_azure_automation_net_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.privatelink_monitor_azure_com_privatelink_monitor_azure_com_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.privatelink_ods_opinsights_azure_com_privatelink_ods_opinsights_azure_com_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.privatelink_oms_opinsights_azure_com_privatelink_oms_opinsights_azure_com_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.bastion_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.firewall_client_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.firewall_management_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip_prefix.fw-pref](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip_prefix) | resource |
| [azurerm_resource_group.nwatcher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_route.force_internet_tunneling](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route.route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.routetable](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_storage_account.storeacc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_subnet.abs_snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.additional_snets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.default_snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.fw_client_snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.fw_management_snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.gw_snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsgassoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.rtassoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.hub_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_string.str](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurenoopsutils_resource_name.bastion](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.bastion_pip](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.fw](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.fw_client_pub_ip](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.fw_mgt_pub_ip](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.fw_policy](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.nsg](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.rt](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.snet](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.st](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.vnet](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_subnets"></a> [add\_subnets](#input\_add\_subnets) | A list of subnets to add to the hub | <pre>map(object({<br>    name                                       = string<br>    address_prefixes                           = list(string)<br>    service_endpoints                          = list(string)<br>    private_endpoint_network_policies_enabled  = bool<br>    private_endpoint_service_endpoints_enabled = bool<br>  }))</pre> | `{}` | no |
| <a name="input_add_tags"></a> [add\_tags](#input\_add\_tags) | Add extra tags | `map(string)` | `{}` | no |
| <a name="input_additional_rules"></a> [additional\_rules](#input\_additional\_rules) | Additional network security group rules to add. For arguements please refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule#argument-reference | <pre>list(object({<br>    priority  = number<br>    name      = string<br>    direction = optional(string, "Inbound")<br>    access    = optional(string, "Allow")<br>    protocol  = optional(string, "Tcp")<br><br>    source_port_range  = optional(string)<br>    source_port_ranges = optional(list(string))<br><br>    destination_port_range  = optional(string)<br>    destination_port_ranges = optional(list(string))<br><br>    source_address_prefix   = optional(string)<br>    source_address_prefixes = optional(list(string))<br><br>    destination_address_prefix   = optional(string)<br>    destination_address_prefixes = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_allowed_cifs_source"></a> [allowed\_cifs\_source](#input\_allowed\_cifs\_source) | Allowed source for inbound CIFS traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| <a name="input_allowed_http_source"></a> [allowed\_http\_source](#input\_allowed\_http\_source) | Allowed source for inbound HTTP traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| <a name="input_allowed_https_source"></a> [allowed\_https\_source](#input\_allowed\_https\_source) | Allowed source for inbound HTTPS traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| <a name="input_allowed_nfs_source"></a> [allowed\_nfs\_source](#input\_allowed\_nfs\_source) | Allowed source for inbound NFSv4 traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| <a name="input_allowed_rdp_source"></a> [allowed\_rdp\_source](#input\_allowed\_rdp\_source) | Allowed source for inbound RDP traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| <a name="input_allowed_ssh_source"></a> [allowed\_ssh\_source](#input\_allowed\_ssh\_source) | Allowed source for inbound SSH traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| <a name="input_allowed_winrm_source"></a> [allowed\_winrm\_source](#input\_allowed\_winrm\_source) | Allowed source for inbound WinRM traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| <a name="input_application_gateway_rules_enabled"></a> [application\_gateway\_rules\_enabled](#input\_application\_gateway\_rules\_enabled) | True to configure rules mandatory for hosting an Application Gateway. See https://docs.microsoft.com/en-us/azure/application-gateway/configuration-infrastructure#allow-access-to-a-few-source-ips | `bool` | `false` | no |
| <a name="input_application_rule_collection"></a> [application\_rule\_collection](#input\_application\_rule\_collection) | application\_rule\_collection = [<br>        {<br>            name     = "default\_app\_rules"<br>            priority = 500<br>            action   = "Allow"<br>            rules = [<br>                {<br>                    name              = "default\_app\_rules\_rule1"<br>                    source\_addresses  = ["10.0.0.0/24"]<br>                    destination\_fqdns = ["www.google.co.uk"]<br>                    protocols         = [<br>                        {<br>                            type = "http"<br>                            port = 80<br>                        },<br>                        {<br>                            type = "https"<br>                            port = 443<br>                        }<br>                    ]<br>                },<br>                {<br>                    name                  = "default\_app\_rules\_rule2"<br>                    source\_addresses      = ["10.0.0.0/24"]<br>                    destination\_fqdn\_tags = ["Windows Update"]<br>                    protocols             = [<br>                        {<br>                            type = "https"<br>                            port = 443<br>                        },<br>                        {<br>                            type = "http"<br>                            port = 80<br>                        },<br>                    ]<br>                }<br>            ]<br>        },<br>        {<br>            name     = "ASE\_app\_rules"<br>            priority = 600<br>            action   = "Allow"<br>            rules = [<br>                {<br>                    name                  = "ASE\_app\_rules\_rule1"<br>                    source\_addresses      = ["10.0.0.0/24"]<br>                    destination\_fqdn\_tags = ["App Service Environment (ASE)"]<br>                    protocols             = [<br>                        {<br>                            type = "https"<br>                            port = 443<br>                        }<br>                    ]<br>                }<br>            ]<br>        }<br>    ] | `map` | `{}` | no |
| <a name="input_azure_bastion_host_sku"></a> [azure\_bastion\_host\_sku](#input\_azure\_bastion\_host\_sku) | The SKU of the Bastion Host. Accepted values are `Basic` and `Standard` | `string` | `"Basic"` | no |
| <a name="input_azure_bastion_public_ip_allocation_method"></a> [azure\_bastion\_public\_ip\_allocation\_method](#input\_azure\_bastion\_public\_ip\_allocation\_method) | Defines the allocation method for this IP address. Possible values are Static or Dynamic | `string` | `"Static"` | no |
| <a name="input_azure_bastion_public_ip_sku"></a> [azure\_bastion\_public\_ip\_sku](#input\_azure\_bastion\_public\_ip\_sku) | The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic | `string` | `"Standard"` | no |
| <a name="input_azure_bastion_service_name"></a> [azure\_bastion\_service\_name](#input\_azure\_bastion\_service\_name) | Specifies the name of the Bastion Host | `string` | `""` | no |
| <a name="input_azure_bastion_subnet_address_prefix"></a> [azure\_bastion\_subnet\_address\_prefix](#input\_azure\_bastion\_subnet\_address\_prefix) | The address prefix to use for the Azure Bastion subnet | `list` | `[]` | no |
| <a name="input_base_policy_id"></a> [base\_policy\_id](#input\_base\_policy\_id) | The ID of the base policy to use for the Azure Firewall. This is used to create a new policy based on the base policy. | `any` | `null` | no |
| <a name="input_bastion_custom_name"></a> [bastion\_custom\_name](#input\_bastion\_custom\_name) | The name of the custom bastion host to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_bastion_pip_custom_name"></a> [bastion\_pip\_custom\_name](#input\_bastion\_pip\_custom\_name) | The name of the custom bastion host pip to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_cifs_inbound_allowed"></a> [cifs\_inbound\_allowed](#input\_cifs\_inbound\_allowed) | True to allow inbound CIFS traffic | `bool` | `false` | no |
| <a name="input_create_ddos_plan"></a> [create\_ddos\_plan](#input\_create\_ddos\_plan) | Create an ddos plan - Default is false | `bool` | `false` | no |
| <a name="input_create_hub_resource_group"></a> [create\_hub\_resource\_group](#input\_create\_hub\_resource\_group) | Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is true. | `bool` | `true` | no |
| <a name="input_create_network_watcher"></a> [create\_network\_watcher](#input\_create\_network\_watcher) | Controls if Network Watcher resources should be created for the Azure subscription | `bool` | `false` | no |
| <a name="input_custom_logging_resource_group_name"></a> [custom\_logging\_resource\_group\_name](#input\_custom\_logging\_resource\_group\_name) | The name of the logging resource group to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_custom_resource_group_name"></a> [custom\_resource\_group\_name](#input\_custom\_resource\_group\_name) | The name of the resource group to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_ddos_plan_name"></a> [ddos\_plan\_name](#input\_ddos\_plan\_name) | The name of AzureNetwork DDoS Protection Plan | `any` | `null` | no |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | Option to enable or disable default tags | `bool` | `true` | no |
| <a name="input_deny_all_inbound"></a> [deny\_all\_inbound](#input\_deny\_all\_inbound) | True to deny all inbound traffic by default | `bool` | `true` | no |
| <a name="input_deploy_environment"></a> [deploy\_environment](#input\_deploy\_environment) | The environment to deploy. It defaults to dev. | `string` | `"dev"` | no |
| <a name="input_disable_bgp_route_propagation"></a> [disable\_bgp\_route\_propagation](#input\_disable\_bgp\_route\_propagation) | Whether to disable the default BGP route propagation on the subnet | `bool` | `false` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of dns servers to use for virtual network | `list` | `[]` | no |
| <a name="input_domain_name_label"></a> [domain\_name\_label](#input\_domain\_name\_label) | Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system | `any` | `null` | no |
| <a name="input_enable_bastion_host"></a> [enable\_bastion\_host](#input\_enable\_bastion\_host) | Enable Bastion Host | `bool` | `false` | no |
| <a name="input_enable_copy_paste"></a> [enable\_copy\_paste](#input\_enable\_copy\_paste) | Is Copy/Paste feature enabled for the Bastion Host? | `bool` | `true` | no |
| <a name="input_enable_file_copy"></a> [enable\_file\_copy](#input\_enable\_file\_copy) | Is File Copy feature enabled for the Bastion Host. Only supported whne `sku` is `Standard` | `bool` | `false` | no |
| <a name="input_enable_firewall"></a> [enable\_firewall](#input\_enable\_firewall) | Controls if Azure Firewall resources should be created for the Azure subscription | `bool` | `true` | no |
| <a name="input_enable_forced_tunneling"></a> [enable\_forced\_tunneling](#input\_enable\_forced\_tunneling) | Route all Internet-bound traffic to a designated next hop instead of going directly to the Internet | `bool` | `true` | no |
| <a name="input_enable_ip_connect"></a> [enable\_ip\_connect](#input\_enable\_ip\_connect) | Is IP Connect feature enabled for the Bastion Host? | `bool` | `false` | no |
| <a name="input_enable_resource_locks"></a> [enable\_resource\_locks](#input\_enable\_resource\_locks) | (Optional) Enable resource locks | `bool` | `false` | no |
| <a name="input_enable_shareable_link"></a> [enable\_shareable\_link](#input\_enable\_shareable\_link) | Is Shareable Link feature enabled for the Bastion Host. Only supported whne `sku` is `Standard` | `bool` | `false` | no |
| <a name="input_enable_tunneling"></a> [enable\_tunneling](#input\_enable\_tunneling) | Is Tunneling feature enabled for the Bastion Host. Only supported whne `sku` is `Standard` | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The Terraform backend environment e.g. public or usgovernment | `string` | `null` | no |
| <a name="input_firewall_config"></a> [firewall\_config](#input\_firewall\_config) | Manages an Azure Firewall configuration | <pre>object({<br>    sku_name          = optional(string)<br>    sku_tier          = optional(string)<br>    dns_servers       = optional(list(string))<br>    private_ip_ranges = optional(list(string))<br>    threat_intel_mode = optional(string)<br>    zones             = optional(list(string))<br>  })</pre> | n/a | yes |
| <a name="input_fw_application_rules"></a> [fw\_application\_rules](#input\_fw\_application\_rules) | List of application rules to apply to firewall. | <pre>list(object({<br>    name             = string<br>    description      = optional(string)<br>    action           = string<br>    source_addresses = optional(list(string))<br>    source_ip_groups = optional(list(string))<br>    fqdn_tags        = optional(list(string))<br>    target_fqdns     = optional(list(string))<br>    protocol = optional(object({<br>      type = string<br>      port = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_fw_client_snet_address_prefix"></a> [fw\_client\_snet\_address\_prefix](#input\_fw\_client\_snet\_address\_prefix) | The address prefix to use for the Firewall subnet | `any` | `null` | no |
| <a name="input_fw_client_snet_private_endpoint_network_policies_enabled"></a> [fw\_client\_snet\_private\_endpoint\_network\_policies\_enabled](#input\_fw\_client\_snet\_private\_endpoint\_network\_policies\_enabled) | Controls if network policies are enabled on the firewall client subnet | `bool` | `false` | no |
| <a name="input_fw_client_snet_private_link_service_network_policies_enabled"></a> [fw\_client\_snet\_private\_link\_service\_network\_policies\_enabled](#input\_fw\_client\_snet\_private\_link\_service\_network\_policies\_enabled) | Controls if private link service network policies are enabled on the firewall client subnet | `bool` | `false` | no |
| <a name="input_fw_client_snet_service_endpoints"></a> [fw\_client\_snet\_service\_endpoints](#input\_fw\_client\_snet\_service\_endpoints) | Service endpoints to add to the firewall client subnet | `list(string)` | `[]` | no |
| <a name="input_fw_intrusion_detection_mode"></a> [fw\_intrusion\_detection\_mode](#input\_fw\_intrusion\_detection\_mode) | Controls if Azure Firewall Intrusion Detection System (IDS) should be enabled for the Azure subscription | `string` | `"Alert"` | no |
| <a name="input_fw_management_snet_address_prefix"></a> [fw\_management\_snet\_address\_prefix](#input\_fw\_management\_snet\_address\_prefix) | The address prefix to use for Firewall managemement subnet to enable forced tunnelling. The Management Subnet used for the Firewall must have the name `AzureFirewallManagementSubnet` and the subnet mask must be at least a `/26`. | `any` | `null` | no |
| <a name="input_fw_management_snet_private_endpoint_network_policies_enabled"></a> [fw\_management\_snet\_private\_endpoint\_network\_policies\_enabled](#input\_fw\_management\_snet\_private\_endpoint\_network\_policies\_enabled) | Controls if network policies are enabled on the firewall management subnet | `bool` | `false` | no |
| <a name="input_fw_management_snet_private_link_service_network_policies_enabled"></a> [fw\_management\_snet\_private\_link\_service\_network\_policies\_enabled](#input\_fw\_management\_snet\_private\_link\_service\_network\_policies\_enabled) | Controls if private link service network policies are enabled on the firewall management subnet | `bool` | `false` | no |
| <a name="input_fw_management_snet_service_endpoints"></a> [fw\_management\_snet\_service\_endpoints](#input\_fw\_management\_snet\_service\_endpoints) | Service endpoints to add to the firewall management subnet | `list(string)` | `[]` | no |
| <a name="input_fw_nat_rules"></a> [fw\_nat\_rules](#input\_fw\_nat\_rules) | List of nat rules to apply to firewall. | <pre>list(object({<br>    name                  = string<br>    description           = optional(string)<br>    action                = string<br>    source_addresses      = optional(list(string))<br>    destination_ports     = list(string)<br>    destination_addresses = list(string)<br>    protocols             = list(string)<br>    translated_address    = string<br>    translated_port       = string<br>  }))</pre> | `[]` | no |
| <a name="input_fw_network_rules"></a> [fw\_network\_rules](#input\_fw\_network\_rules) | List of network rules to apply to firewall. | <pre>list(object({<br>    name                  = string<br>    description           = optional(string)<br>    action                = string<br>    source_addresses      = optional(list(string))<br>    destination_ports     = list(string)<br>    destination_addresses = optional(list(string))<br>    destination_fqdns     = optional(list(string))<br>    protocols             = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_fw_pip_allocation_method"></a> [fw\_pip\_allocation\_method](#input\_fw\_pip\_allocation\_method) | The allocation method of the public IP address | `string` | `"Static"` | no |
| <a name="input_fw_pip_sku"></a> [fw\_pip\_sku](#input\_fw\_pip\_sku) | The SKU of the public IP address | `string` | `"Standard"` | no |
| <a name="input_fw_threat_intelligence_mode"></a> [fw\_threat\_intelligence\_mode](#input\_fw\_threat\_intelligence\_mode) | Controls if Azure Firewall Threat Intelligence should be enabled for the Azure subscription | `string` | `"Alert"` | no |
| <a name="input_gateway_private_endpoint_network_policies_enabled"></a> [gateway\_private\_endpoint\_network\_policies\_enabled](#input\_gateway\_private\_endpoint\_network\_policies\_enabled) | Whether or not to enable network policies on the private endpoint gateway subnet | `any` | `null` | no |
| <a name="input_gateway_private_link_service_network_policies_enabled"></a> [gateway\_private\_link\_service\_network\_policies\_enabled](#input\_gateway\_private\_link\_service\_network\_policies\_enabled) | Whether or not to enable link service network policies on the private link service gateway subnet | `any` | `null` | no |
| <a name="input_gateway_service_endpoints"></a> [gateway\_service\_endpoints](#input\_gateway\_service\_endpoints) | Service endpoints to add to the Gateway subnet | `list(string)` | `[]` | no |
| <a name="input_gateway_subnet_address_prefix"></a> [gateway\_subnet\_address\_prefix](#input\_gateway\_subnet\_address\_prefix) | The address prefix to use for the gateway subnet | `any` | `null` | no |
| <a name="input_http_inbound_allowed"></a> [http\_inbound\_allowed](#input\_http\_inbound\_allowed) | True to allow inbound HTTP traffic | `bool` | `false` | no |
| <a name="input_https_inbound_allowed"></a> [https\_inbound\_allowed](#input\_https\_inbound\_allowed) | True to allow inbound HTTPS traffic | `bool` | `false` | no |
| <a name="input_hub_fw_client_pip_custom_name"></a> [hub\_fw\_client\_pip\_custom\_name](#input\_hub\_fw\_client\_pip\_custom\_name) | The name of the custom virtual network firewall client public IP to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_hub_fw_custom_name"></a> [hub\_fw\_custom\_name](#input\_hub\_fw\_custom\_name) | The name of the custom virtual network firewall to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_hub_fw_mgt_pip_custom_name"></a> [hub\_fw\_mgt\_pip\_custom\_name](#input\_hub\_fw\_mgt\_pip\_custom\_name) | The name of the custom virtual network firewall management public IP to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_hub_fw_policy_custom_name"></a> [hub\_fw\_policy\_custom\_name](#input\_hub\_fw\_policy\_custom\_name) | The name of the custom virtual network firewall policy to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_hub_nsg_custom_name"></a> [hub\_nsg\_custom\_name](#input\_hub\_nsg\_custom\_name) | The name of the custom virtual network network security group to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_hub_private_endpoint_network_policies_enabled"></a> [hub\_private\_endpoint\_network\_policies\_enabled](#input\_hub\_private\_endpoint\_network\_policies\_enabled) | Whether or not to enable network policies on the private endpoint subnet | `any` | `null` | no |
| <a name="input_hub_private_link_service_network_policies_enabled"></a> [hub\_private\_link\_service\_network\_policies\_enabled](#input\_hub\_private\_link\_service\_network\_policies\_enabled) | Whether or not to enable service endpoints on the private endpoint subnet | `any` | `null` | no |
| <a name="input_hub_routtable_custom_name"></a> [hub\_routtable\_custom\_name](#input\_hub\_routtable\_custom\_name) | The name of the custom virtual network route table to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_hub_sa_custom_name"></a> [hub\_sa\_custom\_name](#input\_hub\_sa\_custom\_name) | The name of the custom virtual network storage account to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_hub_snet_custom_name"></a> [hub\_snet\_custom\_name](#input\_hub\_snet\_custom\_name) | The name of the custom virtual network subnet to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_hub_subnet_address_prefix"></a> [hub\_subnet\_address\_prefix](#input\_hub\_subnet\_address\_prefix) | The address prefixes to use for the default subnet | `list(string)` | `[]` | no |
| <a name="input_hub_subnet_service_endpoints"></a> [hub\_subnet\_service\_endpoints](#input\_hub\_subnet\_service\_endpoints) | Service endpoints to add to the default subnet | `list(string)` | `[]` | no |
| <a name="input_hub_vnet_custom_name"></a> [hub\_vnet\_custom\_name](#input\_hub\_vnet\_custom\_name) | The name of the custom virtual network to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_load_balancer_rules_enabled"></a> [load\_balancer\_rules\_enabled](#input\_load\_balancer\_rules\_enabled) | True to configure rules mandatory for hosting a Load Balancer. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | n/a | yes |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | (Optional) id locks are enabled, Specifies the Level to be used for this Lock. | `string` | `"CanNotDelete"` | no |
| <a name="input_metadata_host"></a> [metadata\_host](#input\_metadata\_host) | The metadata host for the Azure Cloud e.g. management.azure.com or management.usgovcloudapi.net. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Optional prefix for the generated name | `string` | `""` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Optional suffix for the generated name | `string` | `""` | no |
| <a name="input_nat_rule_collections"></a> [nat\_rule\_collections](#input\_nat\_rule\_collections) | name     = nat\_rule\_collection1<br>    priority = "300"<br>    action   = "Dnat"     # Only 'Dnat' is possible<br>    rules    = [<br>        {<br>            name                = "nat\_rule\_collection1\_rule1"<br>            protocols           = ["TCP"]<br>            source\_addresses    = ["10.0.0.1", "10.0.0.2"]<br>            destination\_address = "192.168.1.1"<br>            destination\_ports   = ["80"]<br>            translated\_address  = "192.168.0.1"<br>            translated\_port     = "8080"<br>        }<br>    ] | `map` | `{}` | no |
| <a name="input_network_rule_collection"></a> [network\_rule\_collection](#input\_network\_rule\_collection) | network\_rule\_collections = [<br>        {<br>            name = "default\_network\_rules"<br>            priority = "500"<br>            action = "Allow"<br>            rules = [<br>                {<br>                    name                  = "default\_network\_rules\_AllowRDP" <br>                    protocols             = ["TCP"]<br>                    source\_addresses      = ["10.0.0.1"]<br>                    destination\_addresses = ["192.168.0.21"]<br>                    destination\_ports     = ["3389"]<br>                },<br>                {<br>                    name                  = "default\_network\_rules\_AllowSSH" <br>                    protocols             = ["TCP"]<br>                    source\_addresses      = ["10.0.0.1"]<br>                    destination\_addresses = ["192.168.0.22"]<br>                    destination\_ports     = ["22"]<br>                }<br>            ]<br>        }<br>    ] | `map` | `{}` | no |
| <a name="input_nfs_inbound_allowed"></a> [nfs\_inbound\_allowed](#input\_nfs\_inbound\_allowed) | True to allow inbound NFSv4 traffic | `bool` | `false` | no |
| <a name="input_ops_logging_law_custom_name"></a> [ops\_logging\_law\_custom\_name](#input\_ops\_logging\_law\_custom\_name) | The name of the custom operational logging laws workspace to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_ops_logging_sa_custom_name"></a> [ops\_logging\_sa\_custom\_name](#input\_ops\_logging\_sa\_custom\_name) | The name of the custom operational logging storage account to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | A name for the organization. It defaults to anoa. | `string` | `"anoa"` | no |
| <a name="input_rdp_inbound_allowed"></a> [rdp\_inbound\_allowed](#input\_rdp\_inbound\_allowed) | True to allow inbound RDP traffic | `bool` | `false` | no |
| <a name="input_route_table_routes"></a> [route\_table\_routes](#input\_route\_table\_routes) | A map of route table routes to add to the route table | <pre>map(object({<br>    name                   = string<br>    address_prefix         = string<br>    next_hop_type          = string<br>    next_hop_in_ip_address = string<br>  }))</pre> | `{}` | no |
| <a name="input_scale_units"></a> [scale\_units](#input\_scale\_units) | The number of scale units with which to provision the Bastion Host. Possible values are between `2` and `50`. `scale_units` only can be changed when `sku` is `Standard`. `scale_units` is always `2` when `sku` is `Basic`. | `number` | `2` | no |
| <a name="input_ssh_inbound_allowed"></a> [ssh\_inbound\_allowed](#input\_ssh\_inbound\_allowed) | True to allow inbound SSH traffic | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_use_location_short_name"></a> [use\_location\_short\_name](#input\_use\_location\_short\_name) | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| <a name="input_use_naming"></a> [use\_naming](#input\_use\_naming) | Use the Azure CAF naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| <a name="input_virtual_hub"></a> [virtual\_hub](#input\_virtual\_hub) | An Azure Virtual WAN Hub with associated security and routing policies configured by Azure Firewall Manager. Use secured virtual hubs to easily create hub-and-spoke and transitive architectures with native security services for traffic governance and protection. | <pre>object({<br>    virtual_hub_id  = string<br>    public_ip_count = number<br>  })</pre> | `null` | no |
| <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space) | The address space to be used for the Azure virtual network. | `list` | `[]` | no |
| <a name="input_winrm_inbound_allowed"></a> [winrm\_inbound\_allowed](#input\_winrm\_inbound\_allowed) | True to allow inbound WinRM traffic | `bool` | `false` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | A name for the workload. It defaults to hub-core. | `string` | `"hub-core"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_bastion_host_fqdn"></a> [azure\_bastion\_host\_fqdn](#output\_azure\_bastion\_host\_fqdn) | The fqdn of the Bastion Host |
| <a name="output_azure_bastion_host_id"></a> [azure\_bastion\_host\_id](#output\_azure\_bastion\_host\_id) | The resource ID of the Bastion Host |
| <a name="output_azure_bastion_public_ip"></a> [azure\_bastion\_public\_ip](#output\_azure\_bastion\_public\_ip) | The public IP of the virtual network gateway |
| <a name="output_azure_bastion_public_ip_fqdn"></a> [azure\_bastion\_public\_ip\_fqdn](#output\_azure\_bastion\_public\_ip\_fqdn) | Fully qualified domain name of the virtual network gateway |
| <a name="output_azure_bastion_subnet_id"></a> [azure\_bastion\_subnet\_id](#output\_azure\_bastion\_subnet\_id) | The resource ID of Azure bastion subnet |
| <a name="output_ddos_protection_plan"></a> [ddos\_protection\_plan](#output\_ddos\_protection\_plan) | Ddos protection plan details |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | The ID of the Azure Firewall |
| <a name="output_firewall_name"></a> [firewall\_name](#output\_firewall\_name) | The name of the Azure Firewall. |
| <a name="output_firewall_private_ip"></a> [firewall\_private\_ip](#output\_firewall\_private\_ip) | The private ip of firewall. |
| <a name="output_firewall_public_ip"></a> [firewall\_public\_ip](#output\_firewall\_public\_ip) | the public ip of firewall. |
| <a name="output_hub_default_subnet_id"></a> [hub\_default\_subnet\_id](#output\_hub\_default\_subnet\_id) | The id of the default subnet |
| <a name="output_hub_default_subnet_name"></a> [hub\_default\_subnet\_name](#output\_hub\_default\_subnet\_name) | The id of the default subnet |
| <a name="output_hub_nsg_id"></a> [hub\_nsg\_id](#output\_hub\_nsg\_id) | The id of the hub nsg |
| <a name="output_hub_nsg_name"></a> [hub\_nsg\_name](#output\_hub\_nsg\_name) | The name of the hub nsg |
| <a name="output_hub_resource_group_name"></a> [hub\_resource\_group\_name](#output\_hub\_resource\_group\_name) | The name of the hub virtual network resource group |
| <a name="output_hub_virtual_network_address_space"></a> [hub\_virtual\_network\_address\_space](#output\_hub\_virtual\_network\_address\_space) | List of address spaces that are used the virtual network. |
| <a name="output_hub_virtual_network_id"></a> [hub\_virtual\_network\_id](#output\_hub\_virtual\_network\_id) | The id of the hub virtual network |
| <a name="output_hub_virtual_network_name"></a> [hub\_virtual\_network\_name](#output\_hub\_virtual\_network\_name) | The name of the hub virtual network |
| <a name="output_network_watcher_id"></a> [network\_watcher\_id](#output\_network\_watcher\_id) | ID of Network Watcher |
| <a name="output_privatelink_agentsvc_azure_automation_net"></a> [privatelink\_agentsvc\_azure\_automation\_net](#output\_privatelink\_agentsvc\_azure\_automation\_net) | The ip of the Bastion Host |
| <a name="output_privatelink_blob_core_cloudapi_net"></a> [privatelink\_blob\_core\_cloudapi\_net](#output\_privatelink\_blob\_core\_cloudapi\_net) | The ip of the Bastion Host |
| <a name="output_privatelink_monitor_azure_com"></a> [privatelink\_monitor\_azure\_com](#output\_privatelink\_monitor\_azure\_com) | The ip of the Bastion Host |
| <a name="output_privatelink_ods_opinsights_azure_com"></a> [privatelink\_ods\_opinsights\_azure\_com](#output\_privatelink\_ods\_opinsights\_azure\_com) | The ip of the Bastion Host |
| <a name="output_privatelink_oms_opinsights_azure_com"></a> [privatelink\_oms\_opinsights\_azure\_com](#output\_privatelink\_oms\_opinsights\_azure\_com) | The ip of the Bastion Host |
| <a name="output_public_ip_prefix_id"></a> [public\_ip\_prefix\_id](#output\_public\_ip\_prefix\_id) | The id of the Public IP Prefix resource |
| <a name="output_virtual_hub_private_ip_address"></a> [virtual\_hub\_private\_ip\_address](#output\_virtual\_hub\_private\_ip\_address) | The private IP address associated with the Firewall |
| <a name="output_virtual_hub_public_ip_addresses"></a> [virtual\_hub\_public\_ip\_addresses](#output\_virtual\_hub\_public\_ip\_addresses) | The private IP address associated with the Firewall |
<!-- END_TF_DOCS -->