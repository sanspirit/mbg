

resource "azurerm_logic_app_workflow" "logic_app" {
  name                = "aep-logic-app"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name

  definition = <<DEFINITION
{
    "definition": {
        "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
        "contentVersion": "1.0.0.0",
        "parameters": {},
        "triggers": {
            "When_an_alert_is_triggered": {
                "type": "Microsoft.Insights/metricalerts",
                "inputs": {
                    "host": {
                        "connection": {
                            "name": "@parameters('$connections')['microsoftinsights']['connectionId']"
                        }
                    },
                    "method": "post",
                    "body": {
                        "alertRule": "MyAlertRule",
                        "alertTargetIDs": [
                            "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/metrics",
                            "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/metricAlerts/{alertName}"
                        ],
                        "status": "Activated"
                    }
                },
                "recurrence": {
                    "frequency": "Minute",
                    "interval": 1
                }
            }
        },
        "actions": {
            "Create_an_incident_in_ServiceNow": {
                "type": "Http",
                "inputs": {
                    "method": "POST",
                    "uri": "https://newsignaturedev.service-now.com/api/now/table/incident",
                    "body": {
                        "short_description": "Alert triggered",
                        "description": "@triggerBody()",
                        "category": "monitoring",
                        "subcategory": "Azure",
                        "impact": "3",
                        "urgency": "3",
                        "assignment_group": "monitoring"
                    },
                    "authentication": {
                        "type": "Basic",
                        "username": "yourusername",
                        "password": "yourpassword"
                    }
                },
                "runAfter": {}
            }
        },
        "outputs": {}
    },
    "parameters": {
        "$connections": {
            "defaultValue": {},
            "type": "Object"
        }
    }
}
DEFINITION

  parameter {
    name  = "$connections"
    type  = "Object"
    value = <<CONNECTIONS
{
    "value": {
        "microsoftinsights": {
            "connectionId": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/microsoftinsights"
        }
    }
}
CONNECTIONS
  }


}
