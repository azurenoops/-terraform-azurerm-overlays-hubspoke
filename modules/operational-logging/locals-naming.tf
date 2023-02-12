# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  ops_logging_sa_name  = coalesce(var.ops_logging_sa_custom_name, data.azurenoopsutils_resource_name.logging_st.result)
  ops_logging_law_name = coalesce(var.ops_logging_law_custom_name, data.azurenoopsutils_resource_name.laws.result)
}
