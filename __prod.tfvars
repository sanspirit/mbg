environment                    = "prod"
environment_tag                = "Production"
servicebus_sku                 = "Premium"     #TODO: do we need this?
apimanagment_sku               = "Developer_1" #TODO: replace this with Premium or Standard for a Production SLA ?
premium_apimanagment_sku       = "Premium_1"
servicebus_capacity            = 1
snow_instance                  = "newsignature.service-now.com"
snow_userid                    = "#{SNOW_UserId_PROD}#"
snow_userpassword              = "#{SNOW_UserPassword_PROD}#"
snow_clientid                  = "#{SNOW_ClientId_PROD}#"
snow_clientsecret              = "#{SNOW_ClientSecret_PROD}#"
itsm_host                      = "wapi-mbgevp-prod-itsmapi-uks.azurewebsites.net"
itsm_clientid                  = "#{ITSM_ClientId_Prod}#"
itsm_secret                    = "#{ITSM_Secret_Prod}#"
evpportal_azuread_clientid     = "#{EVPPortal_AzureAd_ClientId_PROD}#"
evpportal_azuread_clientsecret = "#{EVPPortal_AzureAd_ClientSecret_PROD}#"
evpportal_azuread_domain       = "#{EVPPortal_AzureAd_Domain_PROD}#"
evpportal_azuread_tenantid     = "#{EVPPortal_AzureAd_TenantId_PROD}#"
evpappinsight_clientid         = "#{EVPAPPINSIGHT_ClientId_Prod}#"
evpappinsight_clientsecret     = "#{EVPAPPINSIGHT_ClientSecret_Prod}#"
