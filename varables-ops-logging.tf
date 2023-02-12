# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#################################
# Ops Logging Configuration   ###
#################################

variable "ops_logging_name" {
  description = "A name for the ops logging. It defaults to ops-logging-core."
  type        = string
  default     = "ops-logging-core"
}

variable "enable_sentinel" {
  description = "Enables an Azure Sentinel Log Analytics Workspace Solution"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_sku" {
  description = "The SKU of the Log Analytics Workspace. Possible values are PerGB2018 and Free. Default is PerGB2018."
  type        = string
  default     = null
}

variable "log_analytics_logs_retention_in_days" {
  description = "The number of days to retain logs for. Possible values are between 30 and 730. Default is 30."
  type        = number
  default     = null
}