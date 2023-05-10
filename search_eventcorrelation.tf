locals {
  eventcorrelation_index_name       = "eventcorrelationindex"
  eventcorrelation_data_source_name = "eventcorrelationdata"
  eventcorrelation_indexer_name     = "eventcorrelationindexer"

  eventcorrelation_data_source_parameters = {
    eventcorrelation_storageaccount_connectionstring = azurerm_storage_account.datalake.primary_connection_string
    container_name                                   = "eventcorrelation"
  }
}


# PUT request to create Cognitive Search data source
resource "null_resource" "eventcorrelation_search_data_source" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command     = <<EOT
          $uri ="https://${azurerm_search_service.instance.name}.search.windows.net:443/datasources/${local.eventcorrelation_data_source_name}?api-version=2020-06-30"
          $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
          $headers.Add("Content-Type", "application/json")
          $headers.Add("api-key", "${azurerm_search_service.instance.primary_key}")
          $headers.Add("host", "${azurerm_search_service.instance.name}.search.windows.net:443")
          $headers.Add("Accept", "*/*")
          $body = @'
		{
		"name": "${local.eventcorrelation_data_source_name}",
		"type": "azuretable",
		"credentials": {
			"connectionString": "${local.eventcorrelation_data_source_parameters.eventcorrelation_storageaccount_connectionstring}"
		},
		"container": {
			"name": "${local.eventcorrelation_data_source_parameters.container_name}"
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
resource "null_resource" "eventcorrelation_search_index" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command     = <<EOT
    $uri = "https://${azurerm_search_service.instance.name}.search.windows.net:443/indexes/${local.eventcorrelation_index_name}?api-version=2020-06-30"
    $headers    = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")
    $headers.Add("api-key", "${azurerm_search_service.instance.primary_key}")
    $headers.Add("host", "${azurerm_search_service.instance.name}.search.windows.net:443")
    $headers.Add("Accept", "*/*")
    $body = @'
    {
      "name": "${local.eventcorrelation_index_name}",
      "defaultScoringProfile": "",
      "fields": [
      {
        "name": "PartitionKey",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "analyzer": "standard.lucene"
      },
      {
        "name": "RowKey",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": true,
        "analyzer": "standard.lucene"
      },
      {
        "name": "Timestamp",
        "type": "Edm.DateTimeOffset",
        "searchable": false,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      },
      {
        "name": "IncidentNumber",
        "type": "Edm.String",
        "searchable": false,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      },
      {
        "name": "IncidentState",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      },
      {
        "name": "SourceAlertState",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      },
      {
        "name": "CiName",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      },
      {
        "name": "CiId",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      },
      {
        "name": "AccountKey",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      },
      {
        "name": "EventId",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      },
      {
        "name": "Type",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      },
      {
        "name": "EventType",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      },
      {
        "name": "Source",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      },
      {
        "name": "Role",
        "type": "Edm.String",
        "searchable": true,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      },
      {
        "name": "CreatedTimestamp",
        "type": "Edm.DateTimeOffset",
        "searchable": false,
        "filterable": true,
        "retrievable": true,
        "sortable": true,
        "facetable": false,
        "key": false
      }
    ],
    "similarity": {
      "@odata.type": "#Microsoft.Azure.Search.BM25Similarity"
    }
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
resource "null_resource" "eventcorrelation_search_indexer" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command     = <<EOT

       $uri = "https://${azurerm_search_service.instance.name}.search.windows.net:443/indexers/${local.eventcorrelation_indexer_name}?api-version=2020-06-30"
        $headers    = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $headers.Add("api-key", "${azurerm_search_service.instance.primary_key}")
        $headers.Add("host", "${azurerm_search_service.instance.name}.search.windows.net:443")
        $headers.Add("Accept", "*/*")
        $body = @'
        {
          "name": "${local.eventcorrelation_indexer_name}",
          "dataSourceName": "${local.eventcorrelation_data_source_name}",
          "targetIndexName": "${local.eventcorrelation_index_name}",
          "schedule": {
            "interval": "PT1H",
            "startTime": "${timestamp()}"
          }
        }
'@
      Write-Output $body
      $headers.Add("ContentLength", $body.length)
      $response = Invoke-RestMethod -Method 'PUT' -Uri $uri -Headers $headers -Body $body
      Write-Output $response
    EOT
    interpreter = ["pwsh", "-Command"]
  }
  depends_on = [null_resource.eventcorrelation_search_index, null_resource.eventcorrelation_search_data_source]
}