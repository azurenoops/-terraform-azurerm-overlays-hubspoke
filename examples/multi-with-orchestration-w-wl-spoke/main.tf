# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

################################
### Hub/Spoke Configuations  ###
################################

###########################################
### Operational Logging Configuration   ###
###########################################

module "mod_operational_logging" {
  providers = { azurerm = azurerm.ops }
  source  = "azurenoops/overlays-hubspoke/azurerm//modules/operational-logging"
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

  ######################################
  ## Private EndPoint Configuration  ###
  ######################################

  # (Required) To enable Private Endpoint
  private_endpoint_subnet_id =  module.mod_ops_network.default_subnet_id

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

#######################################
### Hub Network Configuration       ###
#######################################

module "mod_hub_network" {
  providers = { azurerm = azurerm.hub }
  depends_on = [
    module.mod_operational_logging
  ]
  source  = "azurenoops/overlays-hubspoke/azurerm//modules/virtual-network-hub"
  version = "~> 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  location           = "usgovvirginia"
  deploy_environment = "dev"
  org_name           = "anoa"
  environment        = "usgovernment"
  workload_name      = "hub-core"

  ####################################
  # Network Artifacts Configuration ##
  ####################################

  # (Optional) Enable Network Artifacts for Operations
  # enable_network_artifacts = true

  #########################
  ## Hub Configuration  ###
  #########################

  # (Required)  Hub Virtual Network Parameters   
  virtual_network_address_space = ["10.0.100.0/24"]

  # (Optional) Create DDOS Plan. Default is false
  create_ddos_plan = false

  # (Optional) Hub Network Watcher
  create_network_watcher = false

  # (Required) Hub Subnets 
  # Default Subnets, Service Endpoints
  # This is the default subnet with required configuration, check README.md for more details
  # First address ranges from VNet Address space reserved for Firewall Subnets. 
  # ex.: For 10.0.100.128/27 address space, usable address range start from 10.0.100.0/24 for all subnets.
  # default subnet name will be set as per Azure NoOps naming convention by defaut.
  hub_subnet_address_prefix = ["10.0.100.128/27"]
  hub_subnet_service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
  hub_private_endpoint_network_policies_enabled     = false
  hub_private_link_service_network_policies_enabled = true

  # (Optional) Hub Network Security Group
  # This is default values, do not need this if keeping default values
  # NSG rules are not created by default for Azure NoOps Hub Subnet

  # To deactivate default deny all rule
  deny_all_inbound = false

  # Enable Private Endpoints for Hub
  # enable_hub_private_endpoints = true

  ##############################
  ## Firewall Configuration  ###
  ##############################

 # Firewall Settings
  # By default, Azure NoOps will create Azure Firewall in Hub VNet. 
  # If you do not want to create Azure Firewall, 
  # set enable_firewall to false. This will allow different firewall products to be used (Example: F5).  
  enable_firewall         = true

  # By default, forced tunneling is enabled for Azure Firewall.
  # If you do not want to enable forced tunneling, 
  # set enable_forced_tunneling to false.
  enable_forced_tunneling = true

  // Firewall Subnets
  fw_client_snet_address_prefix        = ["10.0.100.0/26"]
  fw_management_snet_address_prefix    = ["10.0.100.64/26"]
  fw_client_snet_service_endpoints     = []
  fw_management_snet_service_endpoints = []
  //fw_supernet_IP_address               = "10.96.0.0/19"

  # Firewall Config
  # This is default values, do not need this if keeping default values
  firewall_config = {
    sku_name          = "AZFW_VNet"
    sku_tier          = "Premium"
    threat_intel_mode = "Alert"
  }

  # # (Optional) specify the Network rules for Azure Firewall l
  # This is default values, do not need this if keeping default values
  network_rule_collection = [
    {
      name     = "AllowAzureCloud"
      priority = "100"
      action   = "Allow"
      rules = [
        {
          name                  = "AzureCloud"
          protocols             = ["Any"]
          source_addresses      = ["*"]
          destination_addresses = ["AzureCloud"]
          destination_ports     = ["*"]
        }
      ]
    },
    {
      name     = "AllowTrafficBetweenSpokes"
      priority = "200"
      action   = "Allow"
      rules = [
        {
          name                  = "AllSpokeTraffic"
          protocols             = ["Any"]
          source_addresses      = ["10.96.0.0/19"]
          destination_addresses = ["*"]
          destination_ports     = ["*"]
        }
      ]
    }
  ]

  # (Optional) specify the application rules for Azure Firewall
  # This is default values, do not need this if keeping default values
  application_rule_collection = [
    {
      name     = "AzureAuth"
      priority = "110"
      action   = "Allow"
      rules = [
        {
          name              = "msftauth"
          source_addresses  = ["*"]
          destination_fqdns = ["aadcdn.msftauth.net", "aadcdn.msauth.net"]
          protocols = {
            type = "Https"
            port = 443
          }
        }
      ]
    }
  ]

  #############################
  ## Bastion Configuration  ###
  #############################

  # By default, this module will create a bastion host, 
  # and set the argument to `enable_bastion_host = false`, to disable the bastion host.
  enable_bastion_host                 = true
  azure_bastion_host_sku              = "Standard"
  azure_bastion_subnet_address_prefix = ["10.0.100.160/27"]

  # Bastion Public IP
  azure_bastion_public_ip_allocation_method = "Static"
  azure_bastion_public_ip_sku               = "Standard"

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {} # Tags to be applied to all resources
}

##########################################
### Operations Network Configuration   ###
##########################################

module "mod_ops_network" {
  providers = { azurerm = azurerm.ops }
  source  = "azurenoops/overlays-hubspoke/azurerm//modules/virtual-network-spoke"
  version = "~> 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  location           = "usgovvirginia"
  deploy_environment = "dev"
  org_name           = "anoa"
  environment        = "usgovernment"
  workload_name      = "ops-core"

  ##################################################
  ## Operations Spoke Configuration   (Default)  ###
  ##################################################

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
  hub_virtual_network_id = module.mod_hub_network.virtual_network_id

  # Firewall Private IP Address 
  hub_firewall_private_ip_address = module.mod_hub_network.firewall_private_ip

  # (Optional) Operations Network Security Group
  # This is default values, do not need this if keeping default values
  # NSG rules are not created by default for Azure NoOps Hub Subnet

  # To deactivate default deny all rule
  deny_all_inbound = false

  # Network Security Group Rules to apply to the Operatioms Virtual Network
  nsg_additional_rules = [
    {
      name                       = "Allow-Traffic-From-Spokes"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["22", "80", "443", "3389"]
      source_address_prefixes    = ["10.0.120.0/26", "10.0.125.0/26", "10.0.115.0/26"]
      destination_address_prefix = "10.0.110.0/26"
    },
  ]

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {} # Tags to be applied to all resources
}

##########################################
### Identity Network Configuration     ###
##########################################

module "mod_id_network" {
  providers = { azurerm = azurerm.id }
  depends_on = [
    module.mod_operational_logging
  ]
  source  = "azurenoops/overlays-hubspoke/azurerm//modules/virtual-network-spoke"
  version = "~> 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  location           = "usgovvirginia"
  deploy_environment = "dev"
  org_name           = "anoa"
  environment        = "usgovernment"
  workload_name      = "id-core"

  ################################################
  ## Identity Spoke Configuration (Optional)   ###
  ################################################

  # By default, this module will create a identity spoke, 
  # and set the argument to `enable_identity_spoke = false`, to disable the spoke.
  //enable_identity_spoke = true

  # Indicates if the spoke is deployed to the same subscription as the hub. Default is true.
  is_spoke_deployed_to_same_hub_subscription = true

  # Provide valid VNet Address space for spoke virtual network.  
  virtual_network_address_space = ["10.0.120.0/26"]

  # Provide valid subnet address prefix for spoke virtual network. Subnet naming is based on default naming standard
  spoke_subnet_address_prefix = ["10.0.120.0/27"]
  spoke_subnet_service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
  spoke_private_endpoint_network_policies_enabled     = false
  spoke_private_link_service_network_policies_enabled = true

  # Hub Virtual Network ID
  hub_virtual_network_id = module.mod_hub_network.virtual_network_id

  # Firewall Private IP Address 
  hub_firewall_private_ip_address = module.mod_hub_network.firewall_private_ip

  # (Optional) Identity Network Security Group
  # This is default values, do not need this if keeping default values
  # NSG rules are not created by default for Azure NoOps Hub Subnet

  # To deactivate default deny all rule
  deny_all_inbound = false

  # Network Security Group Rules to apply to the Identity Virtual Network
  nsg_additional_rules = [
    {
      name                       = "Allow-Traffic-From-Spokes"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["22", "80", "443", "3389"]
      source_address_prefixes    = ["10.0.110.0/26", "10.0.125.0/26", "10.0.115.0/26"]
      destination_address_prefix = "10.0.120.0/26"
    },
  ]

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {} # Tags to be applied to all resources
}

################################################
### Shared Service Network Configuration     ###
################################################

module "mod_svcs_network" {
  providers = { azurerm = azurerm.svcs }
  depends_on = [
    module.mod_operational_logging
  ]
  source  = "azurenoops/overlays-hubspoke/azurerm//modules/virtual-network-spoke"
  version = "~> 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  location           = "usgovvirginia"
  deploy_environment = "dev"
  org_name           = "anoa"
  environment        = "usgovernment"
  workload_name      = "svcs-core"

  ########################################################
  ## Shared Services Spoke Configuration  (Optional)   ###
  ########################################################

  # By default, this module will create a shared services spoke, 
  # and set the argument to `enable_shared_services_spoke  = false`, to disable the spoke.
  //enable_shared_services_spoke = true

  # Indicates if the spoke is deployed to the same subscription as the hub. Default is true.
  is_spoke_deployed_to_same_hub_subscription = true

  # Provide valid VNet Address space for spoke virtual network.  
  virtual_network_address_space = ["10.0.115.0/26"]

  # Provide valid subnet address prefix for spoke virtual network. Subnet naming is based on default naming standard
  spoke_subnet_address_prefix = ["10.0.115.0/27"]
  spoke_subnet_service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
  spoke_private_endpoint_network_policies_enabled     = false
  spoke_private_link_service_network_policies_enabled = true

  # Hub Virtual Network ID
  hub_virtual_network_id = module.mod_hub_network.virtual_network_id

  # Firewall Private IP Address 
  hub_firewall_private_ip_address = module.mod_hub_network.firewall_private_ip

  # (Optional) Shared Services Network Security Group
  # This is default values, do not need this if keeping default values
  # NSG rules are not created by default for Azure NoOps Hub Subnet

  # To deactivate default deny all rule
  deny_all_inbound = false

  # Network Security Group Rules to apply to the Shared Services Virtual Network
  nsg_additional_rules = [
    {
      name                       = "Allow-Traffic-From-Spokes"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["22", "80", "443", "3389"]
      source_address_prefixes    = ["10.0.110.0/26", "10.0.125.0/26", "10.0.120.0/26"]
      destination_address_prefix = "10.0.115.0/26"
    },
  ]

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {} # Tags to be applied to all resources
}

##########################################
### Workload Network Configuration     ###
##########################################

module "mod_wl_network" {
  providers = { azurerm = azurerm.wl }
  depends_on = [
    module.mod_operational_logging
  ]
  source  = "azurenoops/overlays-hubspoke/azurerm//modules/virtual-network-spoke"
  version = "~> 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  location           = "usgovvirginia"
  deploy_environment = "dev"
  org_name           = "anoa"
  environment        = "usgovernment"
  workload_name      = "wl-core"

  #################################################
  ## Workload Spoke Configuration  (Optional)   ###
  #################################################

  # Indicates if the spoke is deployed to the same subscription as the hub. Default is true.
  is_spoke_deployed_to_same_hub_subscription = true

  # Provide valid VNet Address space for spoke virtual network.  
  virtual_network_address_space = ["10.0.125.0/26"]

  # Provide valid subnet address prefix for spoke virtual network. Subnet naming is based on default naming standard
  spoke_subnet_address_prefix = ["10.0.125.0/27"]
  spoke_subnet_service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
  spoke_private_endpoint_network_policies_enabled     = false
  spoke_private_link_service_network_policies_enabled = true

  # Hub Virtual Network ID
  hub_virtual_network_id = module.mod_hub_network.virtual_network_id

  # Firewall Private IP Address 
  hub_firewall_private_ip_address = module.mod_hub_network.firewall_private_ip

  # (Optional) Workload Network Security Group
  # This is default values, do not need this if keeping default values
  # NSG rules are not created by default for Azure NoOps Hub Subnet

  # To deactivate default deny all rule
  deny_all_inbound = false

  # Network Security Group Rules to apply to the Workload Virtual Network
  nsg_additional_rules = [
    {
      name                       = "Allow-Traffic-From-Spokes"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["22", "80", "443", "3389"]
      source_address_prefixes    = ["10.0.110.0/26", "10.0.115.0/26", "10.0.120.0/26"]
      destination_address_prefix = "10.0.125.0/26"
    },
  ]

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {} # Tags to be applied to all resources
}
