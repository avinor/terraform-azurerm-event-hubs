variable "name" {
  description = "Name of Event Hub Namespace."
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
}

variable "location" {
  description = "Azure location where resources should be deployed."
}

variable "sku" {
  description = "Defines which tier to use. Valid options are Basic and Standard."
}

variable "capacity" {
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace. Valid values range from 1 - 20."
  type        = number
  default     = 1
}

variable "auto_inflate" {
  description = "Is Auto Inflate enabled for the EventHub Namespace, and what is maximum throughput?"
  type        = object({ enabled = bool, maximum_throughput_units = number })
  default     = null
}
}

variable "log_analytics_workspace_id" {
  description = "Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
  default     = null
}

variable "hubs" {
  description = "A list of event hubs to add to namespace."
  type        = list(object({ name = string, partitions = number, message_retention = number, consumers = list(string), keys = list(object({ name = string, listen = bool, send = bool })) }))
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}
