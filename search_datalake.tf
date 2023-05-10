locals {
  eventsdl_index_name       = "eventsdlindex"
  eventsdl_data_source_name = "eventsdldata"
  eventsdl_indexer_name     = "eventsdlindexer"

  eventsdl_data_source_parameters = {
    eventsdl_storageaccount_connectionstring = azurerm_storage_account.datalake.primary_connection_string
    container_name                           = "eventsdl"
  }
}


# PUT request to create Cognitive Search data source
resource "null_resource" "eventsdl_search_data_source" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command     = <<EOT
          $uri ="https://${azurerm_search_service.instance.name}.search.windows.net:443/datasources/${local.eventsdl_data_source_name}?api-version=2020-06-30"
          $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
          $headers.Add("Content-Type", "application/json")
          $headers.Add("api-key", "${azurerm_search_service.instance.primary_key}")
          $headers.Add("host", "${azurerm_search_service.instance.name}.search.windows.net:443")
          $headers.Add("Accept", "*/*")
          $body = @'
		{
		"name": "${local.eventsdl_data_source_name}",
		"type": "adlsgen2",
		"credentials": {
			"connectionString": "${local.eventsdl_data_source_parameters.eventsdl_storageaccount_connectionstring}"
		},
		"container": {
			"name": "${local.eventsdl_data_source_parameters.container_name}"
		}
	}
'@
          $headers.Add("ContentLength", $body.length)
          $response = Invoke-RestMethod -Method 'PUT' -Uri $uri -Headers $headers -Body $body
    EOT
    interpreter = ["pwsh", "-Command"]
  }
}


# PUT request to create Cognitive Search index
resource "null_resource" "eventsdl_search_index" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command     = <<EOT
    $uri = "https://${azurerm_search_service.instance.name}.search.windows.net:443/indexes/${local.eventsdl_index_name}?api-version=2020-06-30"
    $headers    = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")
    $headers.Add("api-key", "${azurerm_search_service.instance.primary_key}")
    $headers.Add("host", "${azurerm_search_service.instance.name}.search.windows.net:443")
    $headers.Add("Accept", "*/*")
    $body = @'
    {
      "name": "${local.eventsdl_index_name}",
      "fields": [
      {
        "name": "metadata_storage_last_modified",
        "type": "Edm.String",
        "searchable": false,
        "filterable": true,
        "retrievable": true,
        "sortable": false,
        "facetable": false,
        "key": true
      },
      {
        "name": "metadata_storage_name",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": false,
        "facetable": false,
        "key": false
      },
      {
        "name": "metadata_storage_path",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": false,
        "facetable": false
      }
    ]
  }
'@
    $headers.Add("ContentLength", $body.length)
    $response = Invoke-RestMethod -Method 'PUT' -Uri $uri -Headers $headers -Body $body
    EOT
    interpreter = ["pwsh", "-Command"]
  }
  depends_on = [azurerm_search_service.instance]
}

## PUT request to create Cognitive Search indexer
resource "null_resource" "eventsdl_search_indexer" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command     = <<EOT
        $uri = "https://${azurerm_search_service.instance.name}.search.windows.net:443/indexers/${local.eventsdl_indexer_name}?api-version=2020-06-30"
        $headers    = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $headers.Add("api-key", "${azurerm_search_service.instance.primary_key}")
        $headers.Add("host", "${azurerm_search_service.instance.name}.search.windows.net:443")
        $headers.Add("Accept", "*/*")
        $body = @'
        {
          "name": "${local.eventsdl_indexer_name}",
          "dataSourceName": "${local.eventsdl_data_source_name}",
          "targetIndexName": "${local.eventsdl_index_name}",
          "schedule": {
            "interval": "PT1H",
            "startTime": "${timestamp()}"
          },
          "parameters": {
            "batchSize": null,
            "maxFailedItems": 0,
            "maxFailedItemsPerBatch": 0,
            "base64EncodeKeys": null,
            "configuration": {
              "dataToExtract": "contentAndMetadata",
              "parsingMode": "default"
            }
          },
          "fieldMappings": [
          {
            "sourceFieldName": "metadata_storage_last_modified",
            "targetFieldName": "metadata_storage_last_modified",
            "mappingFunction": {
              "name": "base64Encode",
              "parameters": null
            }
          }
          ]
        }
'@
      $headers.Add("ContentLength", $body.length)
      $response = Invoke-RestMethod -Method 'PUT' -Uri $uri -Headers $headers -Body $body
    EOT
    interpreter = ["pwsh", "-Command"]
  }
  depends_on = [null_resource.eventsdl_search_index, null_resource.eventsdl_search_data_source]
}