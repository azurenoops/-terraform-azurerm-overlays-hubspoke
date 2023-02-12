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

## Module Usage

## Create resource group

By default, this module will create a resource group and the name of the resource group to be given in an argument `resource_group_name`. If you want to use an existing resource group, specify the existing resource group name, and set the argument to `create_resource_group = false`.

> *If you are using an existing resource group, then this module uses the same resource group location to create all resources in this module.*

## Azure Network DDoS Protection Plan

By default, this module will create a DDoS Protection Plan. You can enable/disable it by appending an argument `create_ddos_plan`. If you want to disable a DDoS plan using this module, set argument `create_ddos_plan = false`.

## Custom DNS servers

This is an optional feature and only applicable if you are using your own DNS servers superseding default DNS services provided by Azure.Set the argument `dns_servers = ["4.4.4.4"]` to enable this option. For multiple DNS servers, set the argument `dns_servers = ["4.4.4.4", "8.8.8.8"]`

## Subnets

This module handles the creation and a list of address spaces for subnets. This module uses `for_each` to create subnets and corresponding service endpoints, service delegation, and network security groups. This module associates the subnets to network security groups as well with additional user-defined NSG rules.  

This module creates 4 subnets by default: Gateway Subnet, AzureFirewallSubnet, ApplicationGateway Subnet and Management Subnet.

Name | Description
---- | -----------
GatewaySubnet| Contain VPN Gateway, Express route Gateway
AzureFirewallSubnet|If added the Firewall module, it Deploys an Azure Firewall that will monitor all incoming and outgoing traffic
ApplicationGateway|This subnet contain an Application Gateway and any other DMZ services
Management|Management subnet for Bastion host, accessible from gateway

Both Gateway Subnet and AzureFirewallSubnet allow traffic out and can have public IPs. ApplicationGateway and Management subnet route traffic through the firewall and does not support public IPs due to asymmetric routing.

## Virtual Network service endpoints

Service Endpoints allows connecting certain platform services into virtual networks.  With this option, Azure virtual machines can interact with Azure SQL and Azure Storage accounts, as if they’re part of the same virtual network, rather than Azure virtual machines accessing them over the public endpoint.

This module supports enabling the service endpoint of your choosing under the virtual network and with the specified subnet. The list of Service endpoints to associate with the subnet values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage` and `Microsoft.Web`.

```hcl
module "vnet-hub" {
  source  = "kumarvna/caf-virtual-network-hub/azurerm"
  version = "2.2.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.1.2.0/24"

      service_endpoints     = ["Microsoft.Storage"]  
    }
  }

# ....omitted

}
```

## Subnet Service Delegation

Subnet delegation enables you to designate a specific subnet for an Azure PaaS service of your choice that needs to be injected into your virtual network. The Subnet delegation provides full control to manage the integration of Azure services into virtual networks.

This module supports enabling the service delegation of your choosing under the virtual network and with the specified subnet.  For more information, check the [terraform resource documentation](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#service_delegation).

```hcl
module "vnet-hub" {
  source  = "kumarvna/caf-virtual-network-hub/azurerm"
  version = "2.2.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.1.2.0/24"

      delegation = {
        name = "demodelegationcg"
        service_delegation = {
          name    = "Microsoft.ContainerInstance/containerGroups"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }
    }
  }

# ....omitted

}
```

## `private_endpoint_network_policies_enabled` - Private Link Endpoint on the subnet

Network policies, like network security groups (NSG), are not supported for Private Link Endpoints. In order to deploy a Private Link Endpoint on a given subnet, you must set the `private_endpoint_network_policies_enabled` attribute to `true`. This setting is only applicable for the Private Link Endpoint, for all other resources in the subnet access is controlled based via the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource.

This module Enable or Disable network policies for the private link endpoint on the subnet. The default value is `false`. If you are enabling the Private Link Endpoints on the subnet you shouldn't use Private Link Services as it's conflicts.

```hcl
module "vnet-hub" {
  source  = "kumarvna/caf-virtual-network-hub/azurerm"
  version = "2.2.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.1.2.0/24"
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
module "vnet-hub" {
  source  = "kumarvna/caf-virtual-network-hub/azurerm"
  version = "2.2.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.1.2.0/24"
      private_link_service_network_policies_enabled = true

        }
      }
    }
  }

# ....omitted

}
```

## Network Security Groups

By default, the network security groups connected to Management and ApplicationGateway will only allow necessary traffic and block everything else (deny-all rule). Use `nsg_inbound_rules` and `nsg_outbound_rules` in this Terraform module to create a Network Security Group (NSG) for each subnet and allow it to add additional rules for inbound flows.

In the Source and Destination columns, `VirtualNetwork`, `AzureLoadBalancer`, and `Internet` are service tags, rather than IP addresses. In the protocol column, Any encompasses `TCP`, `UDP`, and `ICMP`. When creating a rule, you can specify `TCP`, `UDP`, `ICMP` or `*`. `0.0.0.0/0` in the Source and Destination columns represents all addresses.

*You cannot remove the default rules, but you can override them by creating rules with higher priorities.*

```hcl
module "vnet-hub" {
  source  = "kumarvna/caf-virtual-network-hub/azurerm"
  version = "2.2.0"

  # .... omitted
  
  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.1.2.0/24"

      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
        ["weballow", "200", "Inbound", "Allow", "Tcp", "22", "*", ""],
        ["weballow1", "201", "Inbound", "Allow", "Tcp", "3389", "*", ""],
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

## Azure Firewall

Azure Firewall is a managed, cloud-based network security service that protects your Azure Virtual Network resources. It's a fully stateful firewall as a service with built-in high availability and unrestricted cloud scalability.

![firewall-threat](https://docs.microsoft.com/en-us/azure/firewall/media/overview/firewall-threat.png)

Source: [Azure Firewall Documentation](https://docs.microsoft.com/en-us/azure/firewall/overview)

You can centrally create, enforce, and log application and network connectivity policies across subscriptions and virtual networks. Azure Firewall uses a static public IP address for your virtual network resources allowing outside firewalls to identify traffic originating from your virtual network. The service is fully integrated with Azure Monitor for logging and analytics.

This is designed to support hub and spoke architecture in the azure and further security hardening would be recommend to add appropriate firewall application/network/NAT rules to use this for any production workloads.

>### Firewall Availability Zones

Azure Firewall can be configured during deployment to span multiple Availability Zones for increased availability. With Availability Zones, your availability increases to 99.99% uptime.  

To specifies the availability zones in which the Azure Firewall should be created, set the argument `firewall_zones = [1, 2, 3]`.  This is by default is not enabled and set to `none`. There's no additional cost for a firewall deployed in an Availability Zone. However, there are additional costs for inbound and outbound data transfers associated with Availability Zones.

>Note: Availability Zones can only be configured during deployment. You can't modify an existing firewall to include Availability Zones

>### Firewall Rules

This module centrally create allow or deny network filtering rules by source and destination IP address, port, and protocol. Azure Firewall is fully stateful, so it can distinguish legitimate packets for different types of connections. Rules are enforced and logged across multiple subscriptions and virtual networks.

To define the firewall rules, use the input variables `firewall_application_rules`, `firewall_network_rules` and `firewall_nat_rules`.

``` hcl
module "vnet-hub" {
  source  = "kumarvna/caf-virtual-network-hub/azurerm"
  version = "2.2.0"

# ....omitted

  # (Optional) specify the application rules for Azure Firewall
  firewall_application_rules = [
    {
      name             = "microsoft"
      action           = "Allow"
      source_addresses = ["10.0.0.0/8"]
      target_fqdns     = ["*.microsoft.com"]
      protocol = {
        type = "Http"
        port = "80"
      }
    },
  ]

  # (Optional) specify the Network rules for Azure Firewall
  firewall_network_rules = [
    {
      name                  = "ntp"
      action                = "Allow"
      source_addresses      = ["10.0.0.0/8"]
      destination_ports     = ["123"]
      destination_addresses = ["*"]
      protocols             = ["UDP"]
    },
  ]

  # (Optional) specify the NAT rules for Azure Firewall
  # Destination address must be Firewall public IP
  # `fw-public` is a variable value and automatically pick the firewall public IP from module.
  firewall_nat_rules = [
    {
      name                  = "testrule"
      action                = "Dnat"
      source_addresses      = ["10.0.0.0/8"]
      destination_ports     = ["53", ]
      destination_addresses = ["fw-public"]
      translated_port       = 53
      translated_address    = "8.8.8.8"
      protocols             = ["TCP", "UDP", ]
    },
  ]

# ....omitted
}
```

## Network Watcher

This module handle the provision of Network Watcher resource by defining `create_network_watcher` variable. It will enable network watcher, flow logs and traffic analytics for all the subnets in the Virtual Network. Since Azure uses a specific naming standard on network watchers, It will create a resource group `NetworkWatcherRG` and adds the location specific resource.

## Azure Monitoring Diagnostics

Platform logs in Azure, including the Azure Activity log and resource logs, provide detailed diagnostic and auditing information for Azure resources and the Azure platform they depend on. Platform metrics are collected by default and typically stored in the Azure Monitor metrics database. This module enables to send all the logs and metrics to either storage account, event hub or Log Analytics workspace.

## Peering

To peer spoke networks to the hub networks requires the service principal that performs the peering has `Network Contributor` role on hub network. Linking the Spoke to Hub DNS zones, the service principal also needs the `Private DNS Zone Contributor` role on hub network.

## Private DNS Zone

This module facilitates the private DNS zone for the virtual network.  To create a zone, set the domain name for the private DNS zone with variable `private_dns_zone_name`. This will additionally link the virtual network hub to the private DNS zone.  It will assign all principals that have peering access as contributors so, spokes can remain linked to the same zone.

## Recommended naming and tagging conventions

Applying tags to your Azure resources, resource groups, and subscriptions to logically organize them into a taxonomy. Each tag consists of a name and a value pair. For example, you can apply the name `Environment` and the value `Production` to all the resources in production.
For recommendations on how to implement a tagging strategy, see Resource naming and tagging decision guide.

>**Important** :
Tag names are case-insensitive for operations. A tag with a tag name, regardless of the casing, is updated or retrieved. However, the resource provider might keep the casing you provide for the tag name. You'll see that casing in cost reports. **Tag values are case-sensitive.**

An effective naming convention assembles resource names by using important resource information as parts of a resource's name. For example, using these [recommended naming conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging#example-names), a public IP resource for a production SharePoint workload is named like this: `pip-sharepoint-prod-westus-001`.