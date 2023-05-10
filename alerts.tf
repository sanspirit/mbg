resource "azurerm_monitor_action_group" "evptemails" {
  name                = "InternalAlertsAction${upper(var.environment)}"
  resource_group_name = azurerm_resource_group.core.name
  short_name          = "emails${upper(var.environment)}"

  email_receiver {
    name          = "emailtorahul"
    email_address = "rahul.saraf@mbg.cognizant.com"
  }

  email_receiver {
    name          = "emailtomark"
    email_address = "Mark.Piccolo@mbg.cognizant.com"
  }

  email_receiver {
    name          = "emailtosimon"
    email_address = "Simon.Hawke@mbg.cognizant.com"
  }

  email_receiver {
    name          = "emailtobrendan"
    email_address = "brendan.thomas@mbg.cognizant.com"
  }

}

resource "azurerm_monitor_action_group" "aepalertemail" {
  name                = "AEPAlertsAction${upper(var.environment)}"
  resource_group_name = azurerm_resource_group.core.name
  short_name          = "AEPemails${upper(var.environment)}"

  email_receiver {
    name          = "emailtoplatformservicesteam"
    email_address = "platformservicesteam@newsignature.com"
  }
}
resource "azurerm_monitor_scheduled_query_rules_alert" "eventrouterexception-alert" {
  name                = "MBG EVP Event Router Exceptions TF"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  description         = "MBG EVP Event Router Exceptions"

  action {
    action_group = [
      azurerm_monitor_action_group.evptemails.id
    ]
  }
  data_source_id = azurerm_application_insights.main.id

  enabled     = true
  query       = <<-QUERY
  exceptions
    | where cloud_RoleName == 'EventRouter'
  QUERY
  severity    = var.alert_severity_is_error
  frequency   = 5
  time_window = 5
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "evpapimgatewayreqfailed-alert" {
  name                = "MBG EVP APIM Gateway Failed Request TF"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  description         = "MBG EVP APIM Gateway Failed Request"

  action {
    action_group = [
      azurerm_monitor_action_group.evptemails.id
    ]
  }
  data_source_id = azurerm_application_insights.main.id
  enabled        = true
  query          = <<-QUERY
  union requests, dependencies
    | where operation_Name == 'events;rev=1 - receiver' and cloud_RoleName startswith('apim-mbgevp-${var.environment}-${var.shortlocation}')
    | where success == 'False'
  QUERY
  severity       = var.alert_severity_is_error
  frequency      = 5
  time_window    = 5
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }
}

//http 4xx page error codes alert for APIM

resource "azurerm_monitor_metric_alert" "http_4xx_alert" {
  name                = "aep-http_4xx_alert"
  resource_group_name = azurerm_resource_group.core.name
  scopes              = [azurerm_api_management.premium.id]
  description         = "Alert when the number of HTTP 4xx errors exceeds a threshold"
  severity            = 2 # Medium
  enabled             = true
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_name            = "Requests"
    metric_namespace       = "Microsoft.ApiManagement/service"
    aggregation            = "Total"
    operator               = "GreaterThan"
    threshold              = 1
    skip_metric_validation = false

    dimension {
      name     = "GatewayResponseCodeCategory"
      operator = "Include"
      values   = ["4xx"]
    }

  }

  action {
    action_group_id = azurerm_monitor_action_group.aepalertemail.id
  }
}


//http 5xx page error codes alert for APIM

resource "azurerm_monitor_metric_alert" "http_5xx_alert" {
  name                = "aep-http_5xx_alert"
  resource_group_name = azurerm_resource_group.core.name
  scopes              = [azurerm_api_management.premium.id]
  description         = "Alert when the number of HTTP 4xx errors exceeds a threshold"
  severity            = 2 # Medium
  enabled             = true
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_name            = "Requests"
    metric_namespace       = "Microsoft.ApiManagement/service"
    aggregation            = "Total"
    operator               = "GreaterThan"
    threshold              = 1
    skip_metric_validation = false

    dimension {
      name     = "GatewayResponseCodeCategory"
      operator = "Include"
      values   = ["5xx"]
    }

  }

  action {
    action_group_id = azurerm_monitor_action_group.aepalertemail.id
  }
}

// Alerts when Service Bus queue rises above 0

resource "azurerm_monitor_metric_alert" "dead_letter_queue_alert" {
  name                = "aep-dead-letter-queue-alert"
  resource_group_name = azurerm_resource_group.core.name
  scopes              = [azurerm_servicebus_queue.event_message_queue.namespace_id]
  description         = "Alert raised when the number of messages in the Dead Letter queue rises above 0."
  severity            = 2
  enabled             = true
  frequency           = "PT1H"
  window_size         = "PT12H"


  criteria {
    metric_namespace = "Microsoft.ServiceBus/namespaces"
    metric_name      = "DeadletteredMessages"
    aggregation      = "Minimum"
    operator         = "GreaterThan"
    threshold        = 0

  }

  action {
    action_group_id = azurerm_monitor_action_group.aepalertemail.id
  }
}

// Alerts when Service Bus queue rises above 10

resource "azurerm_monitor_metric_alert" "dead_letter_queue_above_10_alert" {
  name                = "aep-dead-letter-queue-above-10-alert"
  resource_group_name = azurerm_resource_group.core.name
  scopes              = [azurerm_servicebus_queue.event_message_queue.namespace_id]
  description         = "Alert raised when the number of messages in the Dead Letter queue rises above 10."
  severity            = 2
  enabled             = true
  frequency           = "PT1H"
  window_size         = "PT12H"


  criteria {
    metric_namespace = "Microsoft.ServiceBus/namespaces"
    metric_name      = "DeadletteredMessages"
    aggregation      = "Minimum"
    operator         = "GreaterThan"
    threshold        = 10

  }

  action {
    action_group_id = azurerm_monitor_action_group.aepalertemail.id
  }
}

// High/Critical severity alert if the number of active messages is greater than 300
resource "azurerm_monitor_metric_alert" "ActiveMessages_alert" {
  name                = "aep-Active-Messages-Over-300-alert"
  resource_group_name = azurerm_resource_group.core.name
  scopes              = [azurerm_servicebus_queue.event_message_queue.namespace_id]
  frequency           = "PT1H"
  window_size         = "PT12H"
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.ServiceBus/namespaces"
    metric_name      = "ActiveMessages"
    operator         = "GreaterThan"
    threshold        = 300
    aggregation      = "Minimum"

  }

  action {
    action_group_id = azurerm_monitor_action_group.aepalertemail.id
  }

}

//metric alert for Web Application Availability monitoring that will periodically ping the APIM endpoint to ensure it is online and available, and alert immediately at High/Critical severity if it becomes unavailable

resource "azurerm_monitor_metric_alert" "web_app_capacity" {
  name                = "aep-APIM-capacity"
  description         = "Alert when the APIM capacity falls less than 0%"
  resource_group_name = azurerm_resource_group.core.name
  scopes              = [azurerm_api_management.premium.id]
  frequency           = "PT5M"
  window_size         = "PT5M"
  severity            = 2
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Capacity"
    aggregation      = "Maximum"
    operator         = "LessThan"
    threshold        = 0

  }

  action {
    action_group_id = azurerm_monitor_action_group.aepalertemail.id
  }

}


// for datalake

resource "azurerm_monitor_metric_alert" "storage_account_alert" {
  name                = "aep-storage-account-alert"
  resource_group_name = azurerm_storage_account.datalake.resource_group_name
  scopes              = [azurerm_storage_account.datalake.id]

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "Availability"
    aggregation      = "Average"
    operator         = "LessThanOrEqual"
    threshold        = 100
  }

  action {
    action_group_id = azurerm_monitor_action_group.aepalertemail.id

  }

  severity    = 2
  description = "Raise a High/Critical Severity if storage availability drops below 100%."
}
