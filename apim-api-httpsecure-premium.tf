resource "azurerm_api_management_api" "premium-secure" {
  name                = "secure"
  resource_group_name = azurerm_api_management.premium.resource_group_name
  api_management_name = azurerm_api_management.premium.name
  revision            = "1"
  display_name        = "secure"
  path                = "secure"
  protocols           = ["https"]

  subscription_required = true
}

resource "azurerm_api_management_subscription" "premium-secure-subscription" {
  display_name        = "Secure API Access"
  api_management_name = azurerm_api_management.premium.name
  resource_group_name = azurerm_api_management.premium.resource_group_name
  api_id              = azurerm_api_management_api.premium-secure.id
  state               = "active"
}

resource "azurerm_api_management_api_operation" "premium-get-alertmanifest" {
  api_management_name = azurerm_api_management.premium.name
  resource_group_name = azurerm_api_management.premium.resource_group_name
  api_name            = azurerm_api_management_api.premium-secure.name
  operation_id        = "GetAlertManifest"
  display_name        = "GetAlertManifest"
  method              = "GET"

  url_template = "/GetAlertManifest"

  request {
    query_parameter {
      name     = "token"
      required = true
      type     = "string"
    }
  }
}

resource "azurerm_api_management_api_operation" "premium-resolve-itsm-ticket" {
  api_management_name = azurerm_api_management.premium.name
  resource_group_name = azurerm_api_management.premium.resource_group_name
  api_name            = azurerm_api_management_api.premium-secure.name
  operation_id        = "ResolveItsmTicket"
  display_name        = "ResolveItsmTicket"
  method              = "PATCH"

  url_template = "/ResolveItsmTicket"

  request {
    query_parameter {
      name     = "ticketNumber"
      required = true
      type     = "string"
    }
  }
}

resource "azurerm_api_management_api_operation_policy" "premium-getalertmanifest-policy" {
  api_management_name = azurerm_api_management.premium.name
  resource_group_name = azurerm_api_management.premium.resource_group_name
  api_name            = azurerm_api_management_api.premium-secure.name
  operation_id        = azurerm_api_management_api_operation.premium-get-alertmanifest.operation_id

  xml_content = <<XML
<!--
    IMPORTANT:
    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.
    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.
    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.
    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.
    - To remove a policy, delete the corresponding policy statement from the policy document.
    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.
    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.
    - Policies are applied in the order of their appearance, from the top down.
    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.
-->
<policies>
    <inbound>
        <base />
        <set-backend-service backend-id="${azurerm_api_management_backend.premium-event-proc-func-be.name}" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>

XML
}

resource "azurerm_api_management_api_operation_policy" "premium-resolveitsmticket-policy" {
  api_management_name = azurerm_api_management.premium.name
  resource_group_name = azurerm_api_management.premium.resource_group_name
  api_name            = azurerm_api_management_api.premium-secure.name
  operation_id        = azurerm_api_management_api_operation.premium-resolve-itsm-ticket.operation_id

  xml_content = <<XML
<!--
    IMPORTANT:
    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.
    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.
    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.
    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.
    - To remove a policy, delete the corresponding policy statement from the policy document.
    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.
    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.
    - Policies are applied in the order of their appearance, from the top down.
    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.
-->
<policies>
    <inbound>
        <base />
        <set-backend-service backend-id="${azurerm_api_management_backend.premium-event-proc-func-be.name}" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>

XML
}