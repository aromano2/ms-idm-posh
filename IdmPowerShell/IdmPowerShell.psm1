﻿function Get-IdmServer {
    [string]"http://localhost:25316"
}

function Search-IdmByFilter {
  <#
  .SYNOPSIS
  Search Identity Manger with an XPath filter
  .DESCRIPTION
  Get one or more resources from Identity Manager by supplying an XPath FILTER, an optional SELECT, and an optional SORT
  .EXAMPLE
  Search-IdmByFilter /ObjectTypeDescription
  .EXAMPLE
  Search-IdmByFilter -Filter /ObjectTypeDescription -Select "DisplayName,Name"
  .PARAMETER Filter
  The XPath Filter with which to search Identity Manager
  .PARAMETER Select
  An array of attribute names that should be retrieved as a part of the search. Defaults to (and always includes) "ObjectID,ObjectType"
  .PARAMETER Sort
  Comma separated list of attributes to sort by, must be in the format of  "AttributeName:SortDirection". For example: BoundObjectType:Ascending,BoundAttributeType:Descending - which would be a valid sort order for BindingDescription objects in Identity Manager
  #>
  [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
  param
  (
    [Parameter(Mandatory=$True,
      ValueFromPipeline=$false,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='XPath filter to search with')]
    [string]$Filter,
    [Parameter(Mandatory=$false,
      ValueFromPipeline=$false,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='Comma-separated list of attributes to return')]
    [string]$Select,
    [Parameter(Mandatory=$false,
      ValueFromPipeline=$false,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='Comma separated list of attributes to sort by, must be in the format of  "AttributeName:SortDirection". For example: BoundObjectType:Ascending,BoundAttributeType:Descending - which would be a valid sort order for BindingDescription objects in Identity Manager')]
    [string]$Sort
  )

  begin {
    $idmApi = Get-IdmServer
  }

  process {
    write-verbose "Beginning process loop"
    $url = "$idmApi/api/resources?filter=$Filter&select=$Select&sort=$Sort"
    Write-Verbose "URL = $url"
    Invoke-RestMethod -Uri $url
  }
}


function Search-IdmByObjectID {
  <#
  .SYNOPSIS
  Search Identity Manger by ObjectID
  .DESCRIPTION
  Get the resource from Identity Manager by supplying its ObjectID, and an optional SELECT
  .EXAMPLE
  Search-IdmByFilter c51c9ef3-2de0-4d4e-b30b-c1a18e79c56e
  .EXAMPLE
  Search-IdmByFilter -ObjectID c51c9ef3-2de0-4d4e-b30b-c1a18e79c56e -Select "DisplayName,Name"
  .PARAMETER ObjectID
  The ObjectID of the resource to retrieve from Identity Manager
  .PARAMETER Select
  An array of attribute names that should be retrieved as a part of the search. Defaults to (and always includes) "ObjectID,ObjectType"
  #>
  [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
  param
  (
    [Parameter(Mandatory=$True,
      Position=0,
      ValueFromPipeline=$True,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='The ObjectID of the resource to retrieve from Identity Manager')]
    [string]$ObjectID,
    [Parameter(Mandatory=$false,
      Position=1,
      ValueFromPipeline=$false,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='Comma-separated list of attributes to return')]
    [string]$Select
  )

  begin {
    $idmApi = Get-IdmServer
  }

  process {
    write-verbose "Beginning process loop"
    $url = "$idmApi/api/resources/$ObjectID`?select=$Select"
    Write-Verbose "URL = $url"
    Invoke-RestMethod -Uri $url
  }
}