locals {
  search_service_name = "${var.azuresearch_service_name}${var.environment}"

  eventstatus_index_name       = "eventstatusindex"
  eventstatus_data_source_name = "eventstatusdata"
  eventstatus_indexer_name     = "eventstatusindexer"

  eventstatus_data_source_parameters = {
    eventstatus_storageaccount_connectionstring = azurerm_storage_account.datalake.primary_connection_string
    container_name                              = "eventstatus"
  }
}

# PUT request to create Cognitive Search data source
resource "null_resource" "eventstatus_search_data_source" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command     = <<EOT
          $uri ="https://${azurerm_search_service.instance.name}.search.windows.net:443/datasources/${local.eventstatus_data_source_name}?api-version=2020-06-30"
          $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
          $headers.Add("Content-Type", "application/json")
          $headers.Add("api-key", "${azurerm_search_service.instance.primary_key}")
          $headers.Add("host", "${azurerm_search_service.instance.name}.search.windows.net:443")
          $headers.Add("Accept", "*/*")
          $body = @'
    {
    "name": "${local.eventstatus_data_source_name}",
    "type": "azuretable",
    "credentials": {
        "connectionString": "${local.eventstatus_data_source_parameters.eventstatus_storageaccount_connectionstring}"
    },
    "container": {
        "name": "${local.eventstatus_data_source_parameters.container_name}"
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
resource "null_resource" "eventstatus_search_index" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command     = <<EOT
    $uri = "https://${azurerm_search_service.instance.name}.search.windows.net:443/indexes/${local.eventstatus_index_name}?api-version=2020-06-30"
    $headers    = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")
    $headers.Add("api-key", "${azurerm_search_service.instance.primary_key}")
    $headers.Add("host", "${azurerm_search_service.instance.name}.search.windows.net:443")
    $headers.Add("Accept", "*/*")
    $body = @'
    {
      "name": "${local.eventstatus_index_name}",
      "defaultScoringProfile": "",
      "fields": [
        {
          "name": "PartitionKey",
          "type": "Edm.String",
          "searchable": true,
          "filterable": true,
          "retrievable": true,
          "sortable": false,
          "facetable": false,
          "key": false,
          "analyzer": "standard.lucene"
        },
        {
          "name": "RowKey",
          "type": "Edm.String",
          "searchable": true,
          "filterable": true,
          "retrievable": true,
          "sortable": false,
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
          "name": "AccountKey",
          "type": "Edm.String",
          "searchable": true,
          "filterable": true,
          "retrievable": true,
          "sortable": false,
          "facetable": false,
          "key": false,
          "analyzer": "standard.lucene"
        },
        {
          "name": "EventId",
          "type": "Edm.String",
          "searchable": true,
          "filterable": true,
          "retrievable": true,
          "sortable": false,
          "facetable": false,
          "key": false,
          "analyzer": "standard.lucene"
        },
        {
          "name": "Source",
          "type": "Edm.String",
          "searchable": true,
          "filterable": true,
          "retrievable": true,
          "sortable": true,
          "facetable": false,
          "key": false,
          "indexAnalyzer": null,
          "searchAnalyzer": null,
          "analyzer": "standard.lucene"
        },
        {
          "name": "Node",
          "type": "Edm.String",
          "searchable": true,
          "filterable": true,
          "retrievable": true,
          "sortable": true,
          "facetable": false,
          "key": false,
          "indexAnalyzer": null,
          "searchAnalyzer": null,
          "analyzer": "standard.lucene"
        },
        {
          "name": "RuleName",
          "type": "Edm.String",
          "searchable": true,
          "filterable": true,
          "retrievable": true,
          "sortable": true,
          "facetable": false,
          "key": false,
          "indexAnalyzer": null,
          "searchAnalyzer": null,
          "analyzer": "standard.lucene"
        },
        {
          "name": "RulePassed",
          "type": "Edm.String",
          "searchable": true,
          "filterable": true,
          "retrievable": true,
          "sortable": true,
          "facetable": false,
          "key": false,
          "indexAnalyzer": null,
          "searchAnalyzer": null,
          "analyzer": "standard.lucene"
        },
        {
          "name": "StatusEntry",
          "type": "Edm.String",
          "searchable": true,
          "filterable": false,
          "retrievable": true,
          "sortable": false,
          "facetable": false,
          "key": false,
          "analyzer": "standard.lucene"
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
resource "null_resource" "eventstatus_search_indexer" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command     = <<EOT

       $uri = "https://${azurerm_search_service.instance.name}.search.windows.net:443/indexers/${local.eventstatus_indexer_name}?api-version=2020-06-30"
        $headers    = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $headers.Add("api-key", "${azurerm_search_service.instance.primary_key}")
        $headers.Add("host", "${azurerm_search_service.instance.name}.search.windows.net:443")
        $headers.Add("Accept", "*/*")
        $body = @'
        {
          "name": "${local.eventstatus_indexer_name}",
          "dataSourceName": "${local.eventstatus_data_source_name}",
          "targetIndexName": "${local.eventstatus_index_name}",
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
  depends_on = [null_resource.eventstatus_search_index, null_resource.eventstatus_search_data_source]
}