# Azure NoOps Virtual Network Spoke Terraform Module

This module deploys a spoke network using the [Microsoft recommended Hub-Spoke network topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke). Usually, only one hub in each region with multiple spokes and each of them can also be in separate subscriptions.

>If you are deploying the spoke VNet in the same Hub Network subscription, then make sure you have set the argument `is_spoke_deployed_to_same_hub_subscription = true`. This helps this module to manage the network watcher, flow logs and traffic analytics resources for all the subnets in the Virtual Network. If you are deploying the spoke virtual networks in separate subscriptions, then set this argument to `false`.

This is designed to quickly deploy hub and spoke architecture in the azure and further security hardening would be recommend to add appropriate NSG rules to use this for any production workloads.

The following reference architecture shows how to implement a hub-spoke topology in Azure. The hub is a virtual network in Azure that acts as a central point of connectivity to an on-premises network. The spokes are virtual networks that peer with the hub and can be used to isolate workloads. Traffic flows between the on-premises datacenter and the hub through an ExpressRoute or VPN gateway connection.

AzureFirewallSubnet and GatewaySubnet will not contain any UDR (User Defined Route) or NSG (Network Security Group). Management and DMZ will route all outgoing traffic through firewall instance.

This is designed to quickly deploy hub and spoke architecture in the azure and further security hardening would be recommend to add appropriate NSG rules to use this for any production workloads.

![hub-spoke-topology](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/images/hub-spoke.png)

Source: [Microsoft Azure Hub-Spoke Topology Documentation](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)


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

## Spoke Resource Group Creation

By default, this module will create a resource group for the Hub and each spoke. If you want to use an existing resource group, specify the existing resource group name, and set the argument to `create_resource_group = false`.

> *If you are using an existing resource group, then this module uses the same resource group location to create all resources in this module.*

## Custom DNS servers

This is an optional feature and only applicable if you are using your own DNS servers superseding default DNS services provided by Azure.Set the argument `dns_servers = ["4.4.4.4"]` to enable this option. For multiple DNS servers, set the argument `dns_servers = ["4.4.4.4", "8.8.8.8"]`

## Subnet

This module handles the creation and a list of address spaces for subnets. This module uses `for_each` to create subnets and corresponding service endpoints, service delegation, and network security groups. This module associates the subnets to network security groups as well with additional user-defined NSG rules.  

This module creates 2 subnets by default: Application Subnet and Database Subnet and both subnets route the traffic through the firewall if `hub_firewall_private_ip_address` argument set else all traffic will forward to VNet.

## Virtual Network service endpoints

Service Endpoints allows connecting certain platform services into virtual networks.  With this option, Azure virtual machines can interact with Azure SQL and Azure Storage accounts, as if they’re part of the same virtual network, rather than Azure virtual machines accessing them over the public endpoint.

This module supports enabling the service endpoint of your choosing under the virtual network and with the specified subnet. The list of Service endpoints to associate with the subnet values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage` and `Microsoft.Web`.

> **Recommendation: It is recommended to set as few service endpoints as possible on Spoke subnets. Storage Endpoint is useful and doesn't clutter the firewall logs. Besides, add other endpoints if those are absolutely necessary.**

```hcl
module "vnet-spoke" {
  source  = "azurenoops/overlays-hubspoke/azurerm/modules/virtual-network-spoke"
  version = "~> 1.0.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.2.2.0/24"

      service_endpoints     = ["Microsoft.Storage"]  
    }
  }

# ....omitted

}
```

## `private_endpoint_network_policies_enabled` - Private Link Endpoint on the subnet

Network policies, like network security groups (NSG), are not supported for Private Link Endpoints. In order to deploy a Private Link Endpoint on a given subnet, you must set the `private_endpoint_network_policies_enabled` attribute to `true`. This setting is only applicable for the Private Link Endpoint, for all other resources in the subnet access is controlled based via the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource.

This module Enable or Disable network policies for the private link endpoint on the subnet. The default value is `false`. If you are enabling the Private Link Endpoints on the subnet you shouldn't use Private Link Services as it's conflicts.

```hcl
module "vnet-spoke" {
  source  = "azurenoops/overlays-hubspoke/azurerm/modules/virtual-network-spoke"
  version = "~> 1.0.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.2.2.0/24"
      private_endpoint_network_policies_enabled = true

        }
      }
    }
  }

# ....omitted

}
```

## `private_link_service_network_policies_enabled` - private link service on the subnet

In order to deploy a Private Link Service on a given subnet, you must set the `private_link_service_network_policies_enabled` attribute to `true`. This setting is only applicable for the Private Link Service, for all other resources in the subnet access is controlled based on the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource.

This module Enable or Disable network policies for the private link service on the subnet. The default value is `false`. If you are enabling the Private Link service on the subnet then, you shouldn't use Private Link endpoints as it's conflicts.

```hcl
module "vnet-spoke" {
  source  = "azurenoops/overlays-hubspoke/azurerm/modules/virtual-network-spoke"
  version = "~> 1.0.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.2.2.0/24"
      private_link_service_network_policies_enabled = true

        }
      }
    }
  }

# ....omitted

}
```

## Network Security Groups

By default, the network security groups connected to all subnets and only allow necessary traffic also block everything else (deny-all rule). Use `nsg_inbound_rules` and `nsg_outbound_rules` in this Terraform module to create a Network Security Group (NSG) for each subnet and allow it to add additional rules for inbound flows.

In the Source and Destination columns, `VirtualNetwork`, `AzureLoadBalancer`, and `Internet` are service tags, rather than IP addresses. In the protocol column, Any encompasses `TCP`, `UDP`, and `ICMP`. When creating a rule, you can specify `TCP`, `UDP`, `ICMP` or `*`. `0.0.0.0/0` in the Source and Destination columns represents all addresses.

>*You cannot remove the default rules, but you can override them by creating rules with higher priorities.*

```hcl
module "vnet-spoke" {
  source  = "azurenoops/overlays-hubspoke/azurerm/modules/virtual-network-spoke"
  version = "~> 1.0.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "application"
      subnet_address_prefix = "10.2.2.0/24"

      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
        ["weballow", "200", "Inbound", "Allow", "Tcp", "80", "*", ""],
        ["weballow1", "201", "Inbound", "Allow", "Tcp", "443", "*", ""],
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
        ["ntp_out", "103", "Outbound", "Allow", "Udp", "123", "", "0.0.0.0/0"],
      ]
    }
  }
}
```

## Azure Monitoring Diagnostics

Platform logs in Azure, including the Azure Activity log and resource logs, provide detailed diagnostic and auditing information for Azure resources and the Azure platform they depend on. Platform metrics are collected by default and typically stored in the Azure Monitor metrics database. This module enables to send all the logs and metrics to either storage account, event hub or Log Analytics workspace.

## Peering to Hub

To peer spoke networks to the hub networks requires the service principal that performs the peering has `Network Contributor` role on hub network. Linking the Spoke to Hub DNS zones, the service principal also needs the `Private DNS Zone Contributor` role on hub network. If Log Analytics workspace is created in hub or another subscription then, the service principal must have `Log Analytics Contributor` role on workspace or a custom role to connect resources to workspace.

## Linking Hub Private DNS Zone

This module facilitates to link the spoke VNet to private DNS preferably created by Hub Module. To create a link to private DNS zone, set the domain name of the private DNS zone with variable `private_dns_zone_name`. This will always set automatic registration of records to `true`.  

## Recommended naming and tagging conventions

Applying tags to your Azure resources, resource groups, and subscriptions to logically organize them into a taxonomy. Each tag consists of a name and a value pair. For example, you can apply the name `Environment` and the value `Production` to all the resources in production.
For recommendations on how to implement a tagging strategy, see Resource naming and tagging decision guide.

>**Important** :
Tag names are case-insensitive for operations. A tag with a tag name, regardless of the casing, is updated or retrieved. However, the resource provider might keep the casing you provide for the tag name. You'll see that casing in cost reports. **Tag values are case-sensitive.**

An effective naming convention assembles resource names by using important resource information as parts of a resource's name. For example, using these [recommended naming conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging#example-names), a public IP resource for a production SharePoint workload is named like this: `pip-sharepoint-prod-westus-001`.