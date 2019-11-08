terraform {
  required_version = ">= 0.12.0"
  required_providers {
    azurerm = "~> 1.36.0"
}
}

locals {
  consumers = flatten([for h in var.hubs :
    [for c in h.consumers : {
      hub  = h.name
      name = c
  }]])

  keys = flatten([for h in var.hubs :
    [for k in h.keys : {
      hub = h.name
      key = k
  }]])
}

resource "azurerm_resource_group" "events" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_eventhub_namespace" "events" {
  name                = "${var.name}-ns"
  location            = azurerm_resource_group.events.location
  resource_group_name = azurerm_resource_group.events.name
  sku                 = var.sku
  capacity            = var.capacity

  auto_inflate_enabled     = var.auto_inflate != null ? var.auto_inflate.enabled : null
  maximum_throughput_units = var.auto_inflate != null ? var.auto_inflate.maximum_throughput_units : null


  tags = var.tags
}

resource "azurerm_eventhub" "events" {
  count               = length(var.hubs)
  name                = var.hubs[count.index].name
  namespace_name      = azurerm_eventhub_namespace.events.name
  resource_group_name = azurerm_resource_group.events.name
  partition_count     = var.hubs[count.index].partitions
  message_retention   = var.hubs[count.index].message_retention
}

resource "azurerm_eventhub_consumer_group" "events" {
  count               = length(local.consumers)
  name                = local.consumers[count.index].name
  namespace_name      = azurerm_eventhub_namespace.events.name
  eventhub_name       = local.consumers[count.index].hub
  resource_group_name = azurerm_resource_group.events.name
  user_metadata       = "terraform"

  depends_on = ["azurerm_eventhub.events"]
}

resource "azurerm_eventhub_authorization_rule" "events" {
  count               = length(local.keys)
  name                = local.keys[count.index].key.name
  namespace_name      = azurerm_eventhub_namespace.events.name
  eventhub_name       = local.keys[count.index].hub
  resource_group_name = azurerm_resource_group.events.name

  listen = local.keys[count.index].key.listen
  send   = local.keys[count.index].key.send
  manage = false

  depends_on = ["azurerm_eventhub.events"]
}

resource "azurerm_monitor_diagnostic_setting" "namespace" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.name}-ns-log-analytics"
  target_resource_id         = azurerm_eventhub_namespace.events.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "ArchiveLogs"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "OperationalLogs"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AutoScaleLogs"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}