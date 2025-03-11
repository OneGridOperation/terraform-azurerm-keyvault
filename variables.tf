variable "environment" {
  description = "(Required) The name of the environment."
  type        = string
  validation {
    condition = contains([
      "dev",
      "test",
      "prod",
    ], var.environment)
    error_message = "Possible values are dev, test, and prod."
  }
}

variable "configuration" {
  description = "(Optional) The configuration for block type arguments."
  type        = any
  default     = null
}

variable "system_short_name" {
  description = <<EOT
  (Required) Short abbreviation (to-three letters) of the system name that this resource belongs to (see naming convention guidelines).
  Will be part of the final name of the deployed resource.
  EOT
  type        = string
}

variable "app_name" {
  description = <<EOT
  (Required) Name of this resource within the system it belongs to (see naming convention guidelines).
  Will be part of the final name of the deployed resource.
  EOT
  type        = string
}

variable "override_name" {
  description = "(Optional) Override the name of the resource. Under normal circumstances, it should not be used."
  default     = null
  type        = string
}

variable "override_location" {
  description = "(Optional) Override the location of the resource. Under normal circumstances, it should not be used."
  default     = null
  type        = string
}

variable "resource_group" {
  description = "(Required) The resource group where this resource should exist."
  type        = any
}

# This `resource_group_name` variable is replaced by the use of `resource_group` variable.
# variable "resource_group_name" {
#   description = "(Required) The name of the resource group where the resource should exist. Changing this forces a new resource to be created."
#   type        = string
# }

# This `location` variable is replaced by the use of `resource_group` variable.
# variable "location" {
#   description = "(Required) The location where the resource should exist. Changing this forces a new resource to be created."
#   type        = string
# }

variable "sku_name" {
  description = "(Optional) The Name of the SKU used for this Key Vault. Possible values are `standard` and `premium`."
  type        = string
  default     = "standard"
  validation {
    condition     = can(regex("^(standard|premium)$", var.sku_name))
    error_message = "Possible values are `standard` and `premium`."
  }
}

variable "tenant_id" {
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Changing this forces a new resource to be created."
  # default     = "00000000-0000-0000-0000-000000000000"
  nullable = false
  type     = string
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$", var.tenant_id))
    error_message = "The tenant_id value must be a valid globally unique identifier (GUID)."
  }
}

# variable "object_id" {
#   description = "(Required) The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Changing this forces a new resource to be created."
#   default     = "00000000-0000-0000-0000-000000000000"
#   nullable    = false
#   type        = string
#   validation {
#     condition     = can(regex("^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$", var.object_id))
#     error_message = "The tenant_id value must be a valid globally unique identifier (GUID)."
#   }
# }

# Use separate `azurerm_key_vault_access_policy` resource to configure `access_policy` variable.
# Since access_policy can be configured both inline and via the separate `azurerm_key_vault_access_policy` resource, we have to explicitly set it to empty slice ([]) to remove it.
# variable "access_policy " {
#   description = "(Optional) A list of up to 16 objects describing access policies, as described below."
#   type = list(object(
#     {
#       application_id          = string
#       certificate_permissions = list(string)
#       key_permissions         = list(string)
#       object_id               = string
#       secret_permissions      = list(string)
#       storage_permissions     = list(string)
#       tenant_id               = string
#     }
#   ))
#   default = null
# }

variable "enabled_for_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to `false`."
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "(Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to `false`."
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to `false`."
  type        = bool
  default     = false
}

variable "enable_rbac_authorization" {
  description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to `false`."
  type        = bool
  default     = false
}

# variable "network_acls_bypass" {
#   description = "(Required) Specifies which traffic can bypass the network rules. Possible values are `AzureServices` and `None`."
#   type        = string
#   default     = "AzureServices"
#   validation {
#     condition     = can(regex("^(AzureServices|None)$", var.network_acls_bypass))
#     error_message = "Possible values are `AzureServices` and `None`."
#   }
# }

# checkov:skip=CKV_AZURE_109: The `default_action` variable defaults to Allow.
# https://docs.bridgecrew.io/docs/ensure-azure-cosmosdb-has-local-authentication-disabled
# tfsec:ignore:azure-keyvault-specify-network-acl
# https://aquasecurity.github.io/tfsec/v1.28.0/checks/azure/keyvault/specify-network-acl/

# variable "network_acls_default_action" {
#   description = "(Required) The Default Action to use when no rules match from `ip_rules` / `virtual_network_subnet_ids`. Possible values are `Allow` and `Deny`. Defaults to `Allow`."
#   type        = string
#   default     = "Allow"
#   validation {
#     condition     = can(regex("^(Allow|Deny)$", var.network_acls_default_action))
#     error_message = "Possible values are `Allow` and `Deny`."
#   }
# }

# variable "network_acls_ip_rules" {
#   description = "(Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault."
#   type        = list(string)
#   default     = null
# }

# variable "network_acls_virtual_network_subnet_ids" {
#   description = "(Optional) One or more Subnet IDs which should be able to access this Key Vault."
#   type        = list(string)
#   default     = null
# }

# https://docs.bridgecrew.io/docs/ensure-the-key-vault-is-recoverable
# checkov:skip=CKV_AZURE_42: The `purge_protection_enabled` variable defaults to false.
# https://docs.bridgecrew.io/docs/ensure-that-key-vault-enables-purge-protection
# checkov:skip=CKV_AZURE_110: The `purge_protection_enabled` variable defaults to false.
# https://aquasecurity.github.io/tfsec/v1.28.0/checks/azure/keyvault/no-purge/
# tfsec:ignore:azure-keyvault-no-purge
variable "purge_protection_enabled" {
  description = "(Optional) Is Purge Protection enabled for this Key Vault? Upstream defaults to `false`. Defaults to `true` in this module."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for this Key Vault. Defaults to `true`."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between `7` and `90` (the default) days."
  type        = number
  default     = 90
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
