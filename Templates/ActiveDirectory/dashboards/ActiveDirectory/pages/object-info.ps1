
function New-UDADObjectInfoTable 
{
  param(
      [string]$Server = $ActiveDirectoryServer,
      [PSCredential]$Credential = $ActiveDirectoryCredential,
      [string]$Id
  )

  $Object = Get-ADObject -Server $Server -Credential $Credential -IncludeDeletedObjects:$EventData.includeDeleted -Identity $Id -Properties *
  New-UDTable -Data $Object.PSObject.Properties -Columns @(
    New-UDTableColumn -Property Name -Title "Name" -Filter
    New-UDTableColumn -Property Value -Title "Value" -Filter -Render { if ($EventData.Value) { $EventData.Value.ToString() } else { "" } }
  ) -Filter -Paging
}

New-UDPage -Name 'Object Info' -Url "Object-Info/:guid" -Content {
    New-UDADObjectInfoTable -Id $Guid
  } -Navigation $Navigation