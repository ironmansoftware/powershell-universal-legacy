
function New-UDADObjectSearch {
    param(
        [string]$Server = $ActiveDirectoryServer,
        [PSCredential]$Credential = $ActiveDirectoryCredential
    )
  
    New-UDForm -Content {
      New-UDTextbox -Label 'Filter' -Id 'filter'
      New-UDCheckbox -Label 'Include Deleted Objects' -Id 'includeDeleted'
      New-UDCheckbox -Label 'Use LDAP filter' -Id 'ldapFilter'
    } -OnSubmit {
      if ($EventData.LdapFilter)
      {
        $Session:Objects = Get-ADObject -Server $Server -Credential $Credential -IncludeDeletedObjects:$EventData.includeDeleted -LdapFilter $EventDat.filter 
      }
      else 
      {
        $Session:Objects = Get-ADObject -Server $Server -Credential $Credential -IncludeDeletedObjects:$EventData.includeDeleted -Filter $EventData.filter 
      }
      
      Sync-UDElement -Id 'adObjects'
    }
  
    New-UDDynamic -Id 'adObjects' -Content {
      if ($Session:Objects -eq $null)
      {
         return
      }
      New-UDTable -Title 'Objects' -Data $Session:Objects -Columns @(
        New-UDTableColumn -Property Name -Title "Name" -Filter
        New-UDTableColumn -Property DistinguishedName -Title "Distinguished Name" -Filter
        New-UDTableColumn -Property ObjectClass -Title "Object Class" -Filter
        New-UDTableColumn -Property ViewObject -Title "View Object" -Render {
          $Guid = $EventData.ObjectGUID
          New-UDButton -Text 'View Object' -OnClick {
             Invoke-UDRedirect "/Object-Info/$Guid"
          }
        }
      ) -Filter
    }
  }
  

New-UDPage -Name 'Object Search' -Content {
    New-UDTypography -Text "Search for objects within AD. By default, standard PowerShell filter syntax is used (e.g. Name -like 'j*')."
    New-UDElement -Tag 'p'
    New-UDADObjectSearch
  } -Navigation $Navigation