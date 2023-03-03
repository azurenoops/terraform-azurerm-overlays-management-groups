# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# credit: andrewCluey
# The following locals are used to define the foundation
# Management Groups deployed by the module and uses
# logic to determine the full Management Group deployment
# hierarchy.
locals {
  root_id             = var.root_id
  root_name           = var.root_name
  root_parent_id      = var.root_parent_id
  root_subscriptionId = var.root_subscriptionId

  # Mandatory foundation Management Groups
  core_management_groups = {
    (local.root_id) = {
      display_name               = local.root_name
      parent_management_group_id = local.root_parent_id
      subscription_ids           = local.root_subscriptionId
      archetype_config           = local.anoa_archetype_config_defaults
    }
  }

  # Map containing all Management Groups to deploy
  management_groups_merge = merge(
    local.core_management_groups,
    var.management_groups
  )

  # Logic to auto-generate values for Management Groups if needed
  # Allows the user to specify the Management Group ID when working with existing
  # Management Groups, or uses standard naming pattern if set to null
  anoa_management_groups_map = {
    for key, value in local.management_groups_merge :
    "${local.provider_path.management_groups}${key}" => {
      id                         = key
      display_name               = value.display_name
      parent_management_group_id = try(length(value.parent_management_group_id) > 0, false) ? replace(lower(value.parent_management_group_id), "/[^a-z0-9]/", "-") : local.root_parent_id
      subscription_ids           = value.subscription_ids
    }
  }
}



# The following locals are used to build the map of Management
# Groups to deploy at each level of the hierarchy.
locals {

  # root Management Group
  azurerm_management_group_level_1 = {
    for key, value in local.anoa_management_groups_map :
    key => value
    if value.parent_management_group_id == local.root_parent_id
  }

  azurerm_management_group_level_2 = {
    for key, value in local.anoa_management_groups_map :
    key => value
    if contains(keys(azurerm_management_group.level_1), try(length(value.parent_management_group_id) > 0, false) ? "${local.provider_path.management_groups}${value.parent_management_group_id}" : local.empty_string)
  }

  azurerm_management_group_level_3 = {
    for key, value in local.anoa_management_groups_map :
    key => value
    if contains(keys(azurerm_management_group.level_2), try(length(value.parent_management_group_id) > 0, false) ? "${local.provider_path.management_groups}${value.parent_management_group_id}" : local.empty_string)
  }

  azurerm_management_group_level_4 = {
    for key, value in local.anoa_management_groups_map :
    key => value
    if contains(keys(azurerm_management_group.level_3), try(length(value.parent_management_group_id) > 0, false) ? "${local.provider_path.management_groups}${value.parent_management_group_id}" : local.empty_string)
  }

  azurerm_management_group_level_5 = {
    for key, value in local.anoa_management_groups_map :
    key => value
    if contains(keys(azurerm_management_group.level_4), try(length(value.parent_management_group_id) > 0, false) ? "${local.provider_path.management_groups}${value.parent_management_group_id}" : local.empty_string)
  }

  azurerm_management_group_level_6 = {
    for key, value in local.anoa_management_groups_map :
    key => value
    if contains(keys(azurerm_management_group.level_5), try(length(value.parent_management_group_id) > 0, false) ? "${local.provider_path.management_groups}${value.parent_management_group_id}" : local.empty_string)
  }
}
