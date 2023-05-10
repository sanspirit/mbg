resource "azurerm_api_management_api" "premium-events" {
  name                = "events"
  resource_group_name = azurerm_api_management.premium.resource_group_name
  api_management_name = azurerm_api_management.premium.name
  revision            = "1"
  display_name        = "events"
  path                = "events"
  protocols           = ["https"]

  subscription_required = false
}

resource "azurerm_api_management_api_operation" "premium-receiver" {

  api_management_name = azurerm_api_management.premium.name
  resource_group_name = azurerm_api_management.premium.resource_group_name
  api_name            = azurerm_api_management_api.premium-events.name
  operation_id        = "receiver"
  display_name        = "receiver"
  method              = "POST"

  url_template = "/receiver"
  request {
    query_parameter {
      name     = "token"
      required = false
      type     = "string"
    }
  }
}

resource "azurerm_api_management_api_operation_policy" "premium-receive-policy" {
  api_management_name = azurerm_api_management.premium.name
  resource_group_name = azurerm_api_management.premium.resource_group_name
  api_name            = azurerm_api_management_api.premium-events.name
  operation_id        = azurerm_api_management_api_operation.premium-receiver.operation_id

  depends_on = [
    azurerm_api_management_named_value.premium-servicebusqueueendpoint,
    azurerm_api_management_named_value.premium-eventqueuesaskey,
    azurerm_key_vault_secret.eventqueuesaskey
  ]

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
        <set-variable name="resourceUri" value="{{servicebusqueueendpoint}}" />
        <set-variable name="sasKeyName" value="${azurerm_servicebus_queue_authorization_rule.event_message_queue_auth_rule.name}" />
        <set-variable name="sasKey" value="{{eventqueuesaskey}}" />
        <set-variable name="token" value="@(context.Request.Url.Query.GetValueOrDefault("token", string.Empty))" />
        <set-header name="Authorization" exists-action="override">
            <value>@{

            // Load variables
            string resourceUri = (string) context.Variables.GetValueOrDefault("resourceUri");
            string sasKeyName = (string) context.Variables.GetValueOrDefault("sasKeyName");
            string sasKey = (string) context.Variables.GetValueOrDefault("sasKey");

            // Set the token lifespan
            System.TimeSpan sinceEpoch = System.DateTime.UtcNow.Subtract(new System.DateTime(1970, 1, 1));
            var expiry = System.Convert.ToString((int)sinceEpoch.TotalSeconds + 60); // 1 minute
            string stringToSign = System.Uri.EscapeDataString(resourceUri) + "\n" + expiry;
            System.Security.Cryptography.HMACSHA256 hmac = new System.Security.Cryptography.HMACSHA256(System.Text.Encoding.UTF8.GetBytes(sasKey));
            var signature = System.Convert.ToBase64String(hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(stringToSign)));

            // Format the sas token
            var sasToken = String.Format("SharedAccessSignature sr={0}&sig={1}&se={2}&skn={3}",
            System.Uri.EscapeDataString(resourceUri), System.Uri.EscapeDataString(signature), expiry, sasKeyName);return sasToken;

            }</value>
        </set-header>
        <set-backend-service base-url="{{servicebusqueueendpoint}}" />
        <rewrite-uri template="/messages" copy-unmatched-params="false" />
        <set-body>@{
                string token = (string) context.Variables.GetValueOrDefault("token");
                JObject envelope = new JObject();
                envelope.Add(new JProperty("token", token));
                envelope.Add(new JProperty("id", context.RequestId.ToString() ));
                envelope.Add(new JProperty("utctimestamp", (string) System.DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ") ));

                envelope.Add(new JProperty("message", context.Request.Body.As<JObject>()));

                return envelope.ToString();
            }</set-body>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
        <set-body>@{
                JObject response = new JObject();
                response.Add(new JProperty("id", context.RequestId.ToString() ));
                return response.ToString();
        }</set-body>
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>

XML
}

