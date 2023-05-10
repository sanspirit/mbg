variable "environment" {
  type = string
}

variable "apim_sku" {
  type    = string
  default = "Developer_1"
}

variable "environment_tag" {
  description = "Display value of environment"
  type        = string
  default     = "Development"
}

variable "app_name" {
  type = string
}

variable "iteration" {
  type = string
}

variable "location" {
  description = "location/region for deployment e.g. uksouth"
  type        = string
}

variable "shortlocation" {
  description = "short version of location/region for deployment e.g. uksouth => uks"
  type        = string
}

variable "client_prefix" {
  description = "Project code, i.e. mbgevp"
  type        = string
}

variable "createdby" {
  description = "Display value of createdby tag"
  type        = string
  default     = "Platform Services"
}

variable "servicebus_sku" {
  description = "Service Bus Namespace SKU"
  type        = string
  default     = "Standard"
}

variable "servicebus_capacity" {
  description = "Service Bus Namespace Capacity"
  type        = number
  default     = 0
}

variable "servicebus_endpoint" {
  description = "Service Bus Endpoint for Queue"
  type        = string
  default     = "https://demo-eventprocessor.servicebus.windows.net/demo-eventprocess"
}

variable "apimanagment_sku" {
  description = "API Management SKU"
  type        = string
  default     = "Developer_1"
}

variable "premium_apimanagment_sku" {
  description = "Premium API Management SKU"
  type        = string
  default     = "Developer_1"
}

variable "snow_instance" {
  description = "Base URL for the ServiceNow Instance (i.e. newsignaturedev.service-now.com)"
  type        = string
  default     = "newsignaturedev.service-now.com"
}

variable "snow_userid" {
  description = "user id servicenow access from itsm service"
  type        = string
  default     = "__SNOW_UserId__"
  sensitive   = true
}

variable "snow_userpassword" {
  description = "user password for servicenow access from itsm service"
  type        = string
  default     = "__SNOW_UserPassword__"
  sensitive   = true
}

variable "snow_clientid" {
  description = "client id for servicenow access from itsm service"
  type        = string
  default     = "__SNOW_ClientId__"
  sensitive   = true
}

variable "snow_clientsecret" {
  description = "client secret for servicenow access from itsm service"
  type        = string
  default     = "__SNOW_ClientSecret__"
  sensitive   = true
}

variable "itsm_clientid" {
  description = "client id for ITSM middleware"
  type        = string
  default     = "__ITSM_ClientId__"
  sensitive   = true
}

variable "itsm_secret" {
  description = "secert for ITSM middleware"
  type        = string
  default     = "__ITSM_Secert__"
  sensitive   = true
}

variable "itsm_host" {
  description = "host name of the itsm system"
  type        = string
  default     = "wapi-mbgevp-dev-itsmapi-uks"
  sensitive   = false
}

variable "alert_severity_is_error" {
  description = "default value for error in azure alerts"
  type        = number
  default     = 1
  sensitive   = false
}

variable "alert_severity_is_critical" {
  description = "default value for critical in azure alerts"
  type        = number
  default     = 0
  sensitive   = false
}

variable "evpportal_azuread_clientid" {
  description = "client id for EVPPortal Azure app registration"
  type        = string
  default     = "__EVPPortal_ClientId__"
  sensitive   = false
}

variable "evpportal_azuread_clientsecret" {
  description = "client secret for EVPPortal Azure app registration"
  type        = string
  default     = "__EVPPortal_ClientSecret__"
  sensitive   = true
}

variable "evpportal_azuread_domain" {
  description = "domain for EVPPortal Azure app registration"
  type        = string
  default     = "__EVPPortal_Domain__"
  sensitive   = false
}

variable "evpportal_azuread_tenantid" {
  description = "tenanit id for EVPPortal Azure app registration"
  type        = string
  default     = "__EVPPortal_TenantId__"
  sensitive   = false
}

variable "evpappinsight_clientid" {
  description = "client id for evpappinsight_clientid"
  type        = string
  default     = "__EVPAPPINSIGHT_ClientId__"
  sensitive   = true
}

variable "evpappinsight_clientsecret" {
  description = "secert for evpappinsight_clientid"
  type        = string
  default     = "__EVPAPPINSIGHT_ClientSecret__"
  sensitive   = true
}

variable "azuresearch_service_name" {
  type        = string
  default     = "evpsearchservice"
  description = "A unique name for the service."
  sensitive   = false
}