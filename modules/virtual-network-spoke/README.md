# Azure NoOps Virtual Network Spoke Terraform Module

This module deploys a spoke network using the [Microsoft recommended Hub-Spoke network topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke). Usually, only one hub in each region with multiple spokes and each of them can also be in separate subscriptions.

>If you are deploying the spoke VNet in the same Hub Network subscription, then make sure you have set the argument `is_spoke_deployed_to_same_hub_subscription = true`. This helps this module to manage the network watcher, flow logs and traffic analytics resources for all the subnets in the Virtual Network. If you are deploying the spoke virtual networks in separate subscriptions, then set this argument to `false`.

## Module Usage

<!-- BEGIN_TF_DOCS -->
## Requirements

```hcl
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_spoke_network" {  
  source  = "azurenoops/overlays-hubspoke/azurerm/modules/virtual-network-spoke"
  version = "~> 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  location           = "eastus"
  deploy_environment = "dev"
  org_name           = "anoa"
  environment        = "public"
  workload_name      = "spoke-core"

  #######################################
  ## Spoke Configuration   (Default)  ###
  #######################################

  # Indicates if the spoke is deployed to the same subscription as the hub. Default is true.
  is_spoke_deployed_to_same_hub_subscription = true

  # Provide valid VNet Address space for spoke virtual network.  
  virtual_network_address_space = ["10.0.110.0/26"]

  # Provide valid subnet address prefix for spoke virtual network. Subnet naming is based on default naming standard
  spoke_subnet_address_prefix = ["10.0.110.0/27"]
  spoke_subnet_service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
  spoke_private_endpoint_network_policies_enabled     = false
  spoke_private_link_service_network_policies_enabled = true

  # Hub Virtual Network ID
  hub_virtual_network_id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-hub-core-dev-eastus/providers/Microsoft.Network/virtualNetworks/vnet-hub-core-dev-eastus"

  # Firewall Private IP Address 
  hub_firewall_private_ip_address = "10.96.0.1/19"

  # (Optional) Operations Network Security Group
  # This is default values, do not need this if keeping default values
  # NSG rules are not created by default for Azure NoOps Hub Subnet

  # To deactivate default deny all rule
  deny_all_inbound = false

  # Network Security Group Rules to apply to the Spoke Virtual Network
  nsg_additional_rules = [
    {
      name                       = "Allow-Traffic-From-Spokes"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["22", "80", "443", "3389"]
      source_address_prefixes    = ["10.0.120.0/26", "10.0.115.0/26"]
      destination_address_prefix = "10.0.110.0/26"
    },
  ]

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = true

  # Tags
  add_tags = {} # Tags to be applied to all resources
}

```

## Providers

| Name | Version |
|------|---------|
| azurenoopsutils | ~> 1.0.4 |
| azurerm | ~> 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| mod\_azregions | azurenoops/overlays-azregions-lookup/azurerm | ~> 1.0.0 |
| mod\_spoke\_rg | azurenoops/overlays-resource-group/azurerm | ~> 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_management_lock.sa_resource_group_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.subnet_resource_group_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.vnet_resource_group_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
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
| [azurerm_resource_group.nwatcher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_route.force_internet_tunneling](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route.route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.routetable](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_storage_account.storeacc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_subnet.additional_snets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.default_snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsgassoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.rtassoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.spoke_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.hub_to_spoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.spoke_to_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurenoopsutils_resource_name.nsg](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.rt](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.snet](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.st](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.vnet](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_resource_group.netwatch](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| add\_subnets | A list of subnets to add to the spoke | <pre>map(object({<br>    name                                       = string<br>    address_prefixes                           = list(string)<br>    service_endpoints                          = list(string)<br>    private_endpoint_network_policies_enabled  = bool<br>    private_endpoint_service_endpoints_enabled = bool<br>  }))</pre> | `{}` | no |
| add\_tags | Add extra tags | `map(string)` | `{}` | no |
| allow\_forwarded\_hub\_traffic | Option allow\_forwarded\_traffic for the hub vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic | `bool` | `false` | no |
| allow\_forwarded\_spoke\_traffic | Option allow\_forwarded\_traffic for the spoke vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic | `bool` | `false` | no |
| allow\_gateway\_hub\_transit | Option allow\_gateway\_transit for the hub vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit | `bool` | `false` | no |
| allow\_gateway\_spoke\_transit | Option allow\_gateway\_transit for the spoke vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit | `bool` | `false` | no |
| allow\_virtual\_hub\_network\_access | Option allow\_virtual\_network\_access for the hub vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access | `bool` | `false` | no |
| allow\_virtual\_spoke\_network\_access | Option allow\_virtual\_network\_access for the spoke vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access | `bool` | `false` | no |
| allowed\_cifs\_source | Allowed source for inbound CIFS traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| allowed\_http\_source | Allowed source for inbound HTTP traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| allowed\_https\_source | Allowed source for inbound HTTPS traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| allowed\_nfs\_source | Allowed source for inbound NFSv4 traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| allowed\_rdp\_source | Allowed source for inbound RDP traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| allowed\_ssh\_source | Allowed source for inbound SSH traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| allowed\_winrm\_source | Allowed source for inbound WinRM traffic. Can be a Service Tag, "*" or a CIDR list. | `any` | `[]` | no |
| application\_gateway\_rules\_enabled | True to configure rules mandatory for hosting an Application Gateway. See https://docs.microsoft.com/en-us/azure/application-gateway/configuration-infrastructure#allow-access-to-a-few-source-ips | `bool` | `false` | no |
| cifs\_inbound\_allowed | True to allow inbound CIFS traffic | `bool` | `false` | no |
| create\_spoke\_resource\_group | Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is true. | `bool` | `true` | no |
| custom\_resource\_group\_name | The name of the resource group to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| deny\_all\_inbound | True to deny all inbound traffic by default | `bool` | `true` | no |
| deploy\_environment | The environment to deploy. It defaults to dev. | `string` | `"dev"` | no |
| disable\_bgp\_route\_propagation | Whether to disable the default BGP route propagation on the subnet | `bool` | `false` | no |
| dns\_servers | List of dns servers to use for virtual network | `list` | `[]` | no |
| enable\_forced\_tunneling\_on\_route\_table | Route all Internet-bound traffic to a designated next hop instead of going directly to the Internet | `bool` | `false` | no |
| enable\_resource\_locks | (Optional) Enable resource locks | `bool` | `false` | no |
| environment | The Terraform backend environment e.g. public or usgovernment | `string` | `null` | no |
| http\_inbound\_allowed | True to allow inbound HTTP traffic | `bool` | `false` | no |
| https\_inbound\_allowed | True to allow inbound HTTPS traffic | `bool` | `false` | no |
| hub\_firewall\_private\_ip\_address | The private IP address of the firewall in the hub virtual network. | `string` | n/a | yes |
| hub\_virtual\_network\_id | The ID of the hub virtual network to peer with the spoke virtual network. | `string` | n/a | yes |
| is\_spoke\_deployed\_to\_same\_hub\_subscription | Indicates if the spoke is deployed to the same subscription as the hub. Default is true. | `bool` | `true` | no |
| load\_balancer\_rules\_enabled | True to configure rules mandatory for hosting a Load Balancer. | `bool` | `false` | no |
| location | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | n/a | yes |
| lock\_level | (Optional) id locks are enabled, Specifies the Level to be used for this Lock. | `string` | `"CanNotDelete"` | no |
| metadata\_host | The metadata host for the Azure Cloud e.g. management.azure.com or management.usgovcloudapi.net. | `string` | `null` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| nfs\_inbound\_allowed | True to allow inbound NFSv4 traffic | `bool` | `false` | no |
| nsg\_additional\_rules | Additional network security group rules to add. For arguements please refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule#argument-reference | <pre>list(object({<br>    priority  = number<br>    name      = string<br>    direction = optional(string, "Inbound")<br>    access    = optional(string, "Allow")<br>    protocol  = optional(string, "Tcp")<br><br>    source_port_range  = optional(string)<br>    source_port_ranges = optional(list(string))<br><br>    destination_port_range  = optional(string)<br>    destination_port_ranges = optional(list(string))<br><br>    source_address_prefix   = optional(string)<br>    source_address_prefixes = optional(list(string))<br><br>    destination_address_prefix   = optional(string)<br>    destination_address_prefixes = optional(list(string))<br>  }))</pre> | `[]` | no |
| org\_name | A name for the organization. It defaults to anoa. | `string` | `"anoa"` | no |
| rdp\_inbound\_allowed | True to allow inbound RDP traffic | `bool` | `false` | no |
| route\_table\_routes | A map of route table routes to add to the route table | <pre>map(object({<br>    name                   = string<br>    address_prefix         = string<br>    next_hop_type          = string<br>    next_hop_in_ip_address = string<br>  }))</pre> | `{}` | no |
| spoke\_fw\_client\_pip\_custom\_name | The name of the custom virtual network firewall client public IP to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| spoke\_fw\_custom\_name | The name of the custom virtual network firewall to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| spoke\_fw\_mgt\_pip\_custom\_name | The name of the custom virtual network firewall management public IP to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| spoke\_nsg\_custom\_name | The name of the custom virtual network network security group to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| spoke\_private\_endpoint\_network\_policies\_enabled | Whether or not to enable network policies on the private endpoint subnet | `any` | `null` | no |
| spoke\_private\_link\_service\_network\_policies\_enabled | Whether or not to enable service endpoints on the private endpoint subnet | `any` | `null` | no |
| spoke\_routtable\_custom\_name | The name of the custom virtual network route table to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| spoke\_sa\_custom\_name | The name of the custom virtual network storage account to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| spoke\_snet\_custom\_name | The name of the custom virtual network subnet to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| spoke\_subnet\_address\_prefix | The address prefixes to use for the default subnet | `list(string)` | `[]` | no |
| spoke\_subnet\_service\_endpoints | Service endpoints to add to the default subnet | `list(string)` | `[]` | no |
| spoke\_vnet\_custom\_name | The name of the custom virtual network to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| ssh\_inbound\_allowed | True to allow inbound SSH traffic | `bool` | `false` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| use\_location\_short\_name | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| use\_naming | Use the Azure CAF naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| use\_remote\_hub\_gateway | Option use\_remote\_gateway for the hub vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways | `bool` | `false` | no |
| use\_remote\_spoke\_gateway | Option use\_remote\_gateway for the spoke vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways | `bool` | `false` | no |
| virtual\_network\_address\_space | The address space to be used for the Azure virtual network. | `list` | `[]` | no |
| winrm\_inbound\_allowed | True to allow inbound WinRM traffic | `bool` | `false` | no |
| workload\_name | A name for the workload. It defaults to spoke-core. | `string` | `"spoke-core"` | no |
## Outputs

| Name | Description |
|------|-------------|
| default\_subnet\_id | The id of the default subnet |
| default\_subnet\_name | The id of the default subnet |
| network\_watcher\_id | ID of Network Watcher |
| nsg\_id | The id of the spoke nsg |
| nsg\_name | The name of the spoke nsg |
| resource\_group\_name | The name of the spoke virtual network resource group |
| virtual\_network\_address\_space | List of address spaces that are used the virtual network. |
| virtual\_network\_id | The id of the spoke virtual network |
| virtual\_network\_name | The name of the spoke virtual network |
<!-- END_TF_DOCS -->
