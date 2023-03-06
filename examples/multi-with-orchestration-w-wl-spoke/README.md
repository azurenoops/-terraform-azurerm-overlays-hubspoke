# Azure SCCA compliant Hub/Spoke Virtual Network Terraform Module

This module deploys a SCCA compliant hub/spoke network using the [Microsoft recommended Hub-Spoke network topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke). Usually, only one hub in each region with multiple spokes and each of them can also be in separate subscriptions.

If you are deploying the spoke VNet in the same Hub Network subscription, then make sure you have set the argument `is_spoke_deployed_to_same_hub_subscription = true`. This helps the module manage the network watcher, flow logs and traffic analytics for all the subnets in the Virtual Network. If you are deploying the spoke VNet's in separate subscriptions, set this argument to `false`.

This is designed to quickly deploy SCCA compliant hub/spoke architecture in the azure and further security hardening would be recommend to add appropriate NSG rules to use this for any production workloads.

## Deployment

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

