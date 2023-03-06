# Azure SCCA compliant Hub/Spoke Virtual Network Terraform Module

This module deploys a SCCA compliant hub/spoke network using the [Microsoft recommended Hub-Spoke network topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke). Usually, only one hub in each region with multiple spokes and each of them can also be in separate subscriptions.

If you are deploying the spoke VNet in the same Hub Network subscription, then make sure you have set the argument `is_spoke_deployed_to_same_hub_subscription = true`. This helps the module manage the network watcher, flow logs and traffic analytics for all the subnets in the Virtual Network. If you are deploying the spoke VNet's in separate subscriptions, set this argument to `false`.

This is designed to quickly deploy SCCA compliant hub/spoke architecture in the azure and further security hardening would be recommend to add appropriate NSG rules to use this for any production workloads.

This example is a advanced way of deploying a Hub/Spoke. This is useful when you want to deploy multiple spoke configurations, other than the 3 tier model (ops, id, shared services).

if you are looking for a simple way to deploy a hub/spoke model, please refer to the [one module example]("./examples/one_module").

## Deployment

### Module Usage

```hcl
# Azurerm provider configuration
provider "azurerm" {
  features {}
}

```

## Terraform Usage

To run this example you need to execute following Terraform commands

```hcl
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when you don't need these resources.

