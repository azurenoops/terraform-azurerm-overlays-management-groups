# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# The following locals are used to convert provided input
# parameters to locals before use elsewhere in the module
locals {
  library_path     = var.library_path
  default_location = var.default_location
  default_tags     = var.tags
}

# The following block of locals are used to avoid using
# empty object types in the code
locals {
  empty_list   = []
  empty_map    = {}
  empty_string = ""
}

# The following locals are used to control time_sleep
# delays between resources to reduce transient errors
# relating to replication delays in Azure
locals {
  default_create_duration_delay  = "30s"
  default_destroy_duration_delay = "0s"
  create_duration_delay = {
    after_azurerm_management_group      = try(var.create_duration_delay["azurerm_management_group"], local.default_create_duration_delay)
    after_azurerm_policy_assignment     = try(var.create_duration_delay["azurerm_policy_assignment"], local.default_create_duration_delay)
    after_azurerm_policy_definition     = try(var.create_duration_delay["azurerm_policy_definition"], local.default_create_duration_delay)
    after_azurerm_policy_set_definition = try(var.create_duration_delay["azurerm_policy_set_definition"], local.default_create_duration_delay)
    after_azurerm_role_assignment       = try(var.create_duration_delay["azurerm_role_assignment"], local.default_create_duration_delay)
    after_azurerm_role_definition       = try(var.create_duration_delay["azurerm_role_definition"], local.default_create_duration_delay)
  }
  destroy_duration_delay = {
    after_azurerm_management_group      = try(var.destroy_duration_delay["azurerm_management_group"], local.default_destroy_duration_delay)
    after_azurerm_policy_assignment     = try(var.destroy_duration_delay["azurerm_policy_assignment"], local.default_destroy_duration_delay)
    after_azurerm_policy_definition     = try(var.destroy_duration_delay["azurerm_policy_definition"], local.default_destroy_duration_delay)
    after_azurerm_policy_set_definition = try(var.destroy_duration_delay["azurerm_policy_set_definition"], local.default_destroy_duration_delay)
    after_azurerm_role_assignment       = try(var.destroy_duration_delay["azurerm_role_assignment"], local.default_destroy_duration_delay)
    after_azurerm_role_definition       = try(var.destroy_duration_delay["azurerm_role_definition"], local.default_destroy_duration_delay)
  }
}

# The following locals are used to define base Azure
# provider paths and resource types
locals {
  provider_path = {
    management_groups = "/providers/Microsoft.Management/managementGroups/"
    role_assignment   = "/providers/Microsoft.Authorization/roleAssignments/"
  }
  resource_types = {
    policy_definition     = "Microsoft.Authorization/policyDefinitions"
    policy_set_definition = "Microsoft.Authorization/policySetDefinitions"
  }
}

# The following locals are used to define the management group archetype type
locals {
  # archetypes
  anoa_archetype_config_defaults = {
    (local.root_id) = {
      archetype_id   = "org_root"
      parameters     = local.empty_map
      access_control = local.empty_map
    }
  }
}
