
  function New-UDADRestoreDeletedUserTable {
    <#
    .SYNOPSIS
    Creates a table to restore deleted users. 
    
    .DESCRIPTION
    Creates a table to restore deleted users. 
    
    .PARAMETER Server
    The domain or domain controller to connect to. 
    
    .PARAMETER Credential
    The credential used to connect to the domain.
    #>
    param(
        [string]$Server = $ActiveDirectoryServer,
        [PSCredential]$Credential = $ActiveDirectoryCredential
    )

    $Columns = @(
        New-UDTableColumn -Property Name -Title "Name" -Filter
        New-UDTableColumn -Property DistinguishedName -Title "Distinguished Name" -Filter
        New-UDTableColumn -Property Restore -Title Restore -Render {
            $Item = $EventData
            New-UDButton -Id "btn$($Item.ObjectGuid)" -Text "Restore" -OnClick { 
                Show-UDToast -Message "Restoring user $($Item.Name)" -Duration 5000

                try 
                {
                    Restore-ADObject -Identity $Item.DistinguishedName -Server $EventData.Server -Credential $EventData.Credential
                    Show-UDToast -Message "Restored user $($Item.Name)" -Duration 5000 
                    Sync-UDElement -Id 'Table'
                }
                catch 
                {
                    Show-UDToast -Message "Failed to restore user $($_.Exception)" -BackgroundColor red -MessageColor white -Duration 5000
                }
            }
        }
    )

    New-UDDynamic -Id 'Table' -Content {
      $DeletedUsers = Get-ADObject -Filter 'IsDeleted -eq $true -and objectClass -eq "user"' -IncludeDeletedObjects  -Server $Server -Credential $Credential | ForEach-Object {
          @{
              distinguishedname = $_.DistinguishedName
              name = $_.Name
              server = $Server
              credential = $Credential
          }
      }

      if ($DeletedUsers -eq $null)
      {
        New-UDTypography -Text 'No deleted users'
      }
      else 
      {
        New-UDButton -Text 'Restore Selected' -OnClick {
          Show-UDToast -Message "Restoring selected users..." -Duration 5000
          (Get-UDElement -Id 'users').SelectedRows | ForEach-Object {
                try 
                {
                    Restore-ADObject -Identity $_.DistinguishedName -Server $Server -Credential $Credential
                    
                    
                }
                catch 
                {
                    Show-UDToast -Message "Failed to restore user $($_.Exception)" -BackgroundColor red -MessageColor white -Duration 5000
                }
          }
          Show-UDToast -Message "Restored users" -Duration 5000 
          Sync-UDElement -Id 'Table'
        }
        New-UDTable -Id 'users' -Data $DeletedUsers -Columns $Columns -Filter -ShowSelection
        
      }
    } -LoadingComponent {
      New-UDProgress -Circular
    }
}

New-UDPage -Name 'Restore Deleted User' -Content {
    New-UDTypography -Text 'Restore deleted users from the Active Directory recycling bin. You can selected multiple users to restore and click the Restore Selected to do so.'
    New-UDElement -Tag 'p'
    New-UDADRestoreDeletedUserTable
  } -Navigation $Navigation