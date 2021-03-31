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
  default     = "Standard"
}

variable "capacity" {
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace. Valid values range from 1 - 20."
  type        = number
  default     = 1
}

variable "auto_inflate" {
  description = "Is Auto Inflate enabled for the EventHub Namespace, and what is maximum throughput?"
  type = object({
    enabled                  = bool
    maximum_throughput_units = number
  })
  default = null
}

variable "diagnostics" {
  description = "Diagnostic settings for those resources that support it. See README.md for details on configuration."
  type = object({
    destination   = string
    eventhub_name = string
    logs          = list(string)
    metrics       = list(string)
  })
  default = null
}

variable "network_rules" {
  description = "Network rules restricting access to the event hub."
  type = object({
    ip_rules   = list(string)
    subnet_ids = list(string)
  })
  default = null
}

variable "authorization_rules" {
  description = "Authorization rules to add to the namespace. For hub use `hubs` variable to add authorization keys."
  type = list(object({
    name   = string
    listen = bool
    send   = bool
    manage = bool
  }))
  default = []
}

variable "hubs" {
  description = "A list of event hubs to add to namespace."
  type = list(object({
    name              = string
    partitions        = number
    message_retention = number
    consumers         = list(string)
    keys = list(object({
      name   = string
      listen = bool
      send   = bool
    }))
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}
