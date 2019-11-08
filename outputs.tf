output "namespace_id" {
  description = "Id of Event Hub Namespace."
  value       = azurerm_eventhub_namespace.events.id
}

output "hub_ids" {
  description = "Map of hubs and their ids."
  value       = { for h in azurerm_eventhub.events.* : h.name => h.id }
}

output "keys" {
  description = "Map of hubs with keys => primary_key / secondary_key mapping."
  sensitive   = true
  value = { for k, h in local.keys : h.key.name => {
    primary_key   = azurerm_eventhub_authorization_rule.events[k].primary_key
    secondary_key = azurerm_eventhub_authorization_rule.events[k].secondary_key
    }
  }
}