# IMPORTANT 

> ALERT: This repo will be archived soon. Please use the new modules for creating Hub/Spoke models. 
> - Management Hub: https://github.com/azurenoops/terraform-azurerm-overlays-management-hub
> - Management Spoke: https://github.com/azurenoops/terraform-azurerm-overlays-management-spoke
<BR/>
<BR/>
<BR/>

# Azure SCCA Compliant Hub/Spoke Landing Zone Overlay Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azuremoops/terraform-azurerm-overlays-hubspoke/azurerm/)

A terraform feature which includes modules needed to create an SCCA compliant Hub/Spoke Landing Zone based on the [Microsoft Azure Hub-Spoke Architecture](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli) and can be used with the [Azure NoOps Accelerator](http://aka.ms/azurenoops).

Overlay Feature includes:

* [Hub/Spoke Virtual Networks](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html)
* [Subnets](https://www.terraform.io/docs/providers/azurerm/r/subnet.html)
* [Subnet Service Delegation](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#delegation)
* [Virtual Network service endpoints](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#service_endpoints)
* [Private Link service/Endpoint network policies on Subnet](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#enforce_private_link_endpoint_network_policies)
* [Azure Virtual Network DDoS Protection Plan](https://www.terraform.io/docs/providers/azurerm/r/network_ddos_protection_plan.html)
* [Network Security Groups](https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html)
* [Routing traffic to Hub firewall](https://www.terraform.io/docs/providers/azurerm/r/route_table.html)
* [Peering to Hub Network](https://www.terraform.io/docs/providers/azurerm/r/role_assignment.html)
* [Azure Log Analytics](https://www.terraform.io/docs/providers/azurerm/r/log_analytics.html)
* [Network Watcher](https://www.terraform.io/docs/providers/azurerm/r/network_watcher.html)
* [Network Watcher Workflow Logs](https://www.terraform.io/docs/providers/azurerm/r/network_watcher_flow_log.html)
* [Linking Hub Private DNS Zone](https://www.terraform.io/docs/providers/azurerm/r/private_dns_zone.html)

This terraform feature is a highly opinionated Infrastructure-as-Code (IaC) template that addresses a narrowly scoped, specific need for a Secure Cloud Computing Architecture (SCCA) compliant hub and spoke infrastructure. Many IT oversight organizations can use this module to create a cloud management system to deploy Azure environments for their workloads and teams.

* Designed for US Government mission customers
* Implements SCCA controls following Microsoft's SACA implementation guidance
* Deployable in Azure commercial, Azure Government, Azure Government Secret, and Azure Government Top Secret clouds
* A simple solution with low configuration and narrow scope

## Scope

This terraform feature is designed to create a hub and spoke network topology in Azure. It is not designed to be a one-size-fits-all solution.

Scope of this feature includes:

* Hub and spoke networking intended to comply with SCCA controls
* Predefined spokes for identity, operations, shared services, and workloads
* Ability to create multiple, isolated workloads or team subscriptions
* Remote Access
* Private Endpoints for Azure services
* Compatibility with SCCA compliance (and other compliance frameworks)
* Security using standard Azure tools with sensible defaults

## Networking

Networking is set up in a hub and spoke design, separated by tiers: T0 (Identity and Authorization), T1 (Infrastructure Operations), T2 (DevSecOps and Shared Services), and multiple T3s (Workloads). Access control can be configured to allow separation of duties between all tiers.

## Subscriptions

This terraform feature is designed to be deployed in multiple subscriptions. Most organizations will deploy each tier to a separate Azure subscription, but multiple subscriptions are not required. A single subscription deployment is good for a testing and evaluation, or possibly a small IT Admin team.

## Compliance

This terraform feature is designed to be compliant with the Secure Cloud Computing Architecture (SCCA) controls. It is not designed to be a one-size-fits-all solution. It is designed to be a starting point for a cloud management system that can be used to deploy Azure environments for your workloads and teams.

It is designed to be compliant with the following compliance frameworks:

* [Secure Cloud Computing Architecture (SCCA)](https://www.cisa.gov/secure-cloud-computing-architecture)

## Security

This terraform feature is designed to be secure by default. It uses standard Azure tools with sensible defaults.

## Deployment

View the [deployment example](./examples/complete/one_module/readme.md) for more information on how to deploy this feature.

## Product Roadmap

This terraform feature is in active development.

The following features are planned for future releases:

* Add support for other types of Firewalls
* Add support for Private Endpoints in Shared Service Vnet
