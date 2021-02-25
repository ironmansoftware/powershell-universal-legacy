function New-UDADPasswordResetForm {
    <#
    .SYNOPSIS
    Creates a form to reset a Active Directory password.
    
    .DESCRIPTION
    Creates a form to reset a Active Directory password.
    
    .PARAMETER Server
    The domain or domain controller to connect to.
    
    .PARAMETER Credential
    The credential required for accessing the domain.
    
    .EXAMPLE
    New-UDADPasswordResetForm 

    Creates a form for resetting a user's password. The server and domain will use the variables $ADServer and $ADCredential.
    #>
    param(
        [string]$Server = $ADServer,
        [PSCredential]$Credential = $ADCredential
    )
    New-UDForm -Content {
      New-UDTextbox -Id 'txtIdentity' -Label 'User Name' 
      New-UDTextbox -Id 'txtPassword' -Label 'Password' -Type password 
      New-UDCheckbox -Id 'chkUnlock' -Label 'Unlock'
      New-UDCheckbox -Id 'chkChangePasswordOnLogon' -Label 'Change password on logon' 
    } -OnSubmit {
      $SecurePassword = ConvertTo-SecureString $EventData.txtPassword -AsPlainText -Force
      
      Set-ADAccountPassword -Identity $EventData.txtIdentity -NewPassword $SecurePassword -Reset -Server $Server -Credential $Credential
      
      if ($EventData.chkUnlock)
      {
          Unlock-ADAccount –Identity $EventData.txtIdentity -Server $Server -Credential $Credential
      }
      
      if ($EventData.chkChangePasswordOnLogon)
      {
          Set-ADUser –Identity $EventData.txtIdentity -ChangePasswordAtLogon $true -Server $Server -Credential $Credential
      }
    }
  }

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
        [string]$Server = $ADServer,
        [PSCredential]$Credential = $ADCredential
    )

    $Columns = @(
        New-UDTableColumn -Property Name -Title "Name"
        New-UDTableColumn -Property DistinguishedName -Title "Distinguished Name"
        New-UDTableColumn -Property Restore -Title Restore -Render {
            $Item = $EventData
            New-UDButton -Id "btn$($Item.ObjectGuid)" -Text "Restore" -OnClick { 
                Show-UDToast -Message "Restoring user $($Item.Name)" -Duration 5000

                try 
                {
                    Restore-ADObject -DistinguishedName $Item.DistinguishedName -Server $Server -Credential $Credential
                    Show-UDToast -Message "Restored user $($Item.Name)" -Duration 5000 
                }
                catch 
                {
                    Show-UDToast -Message "Failed to restore user $($_.Exception)" -BackgroundColor red -MessageColor white -Duration 5000
                }
            }
        }
    )

    $DeletedUsers = Get-ADObject -Filter 'IsDeleted -eq $true -and objectClass -eq "user"' -IncludeDeletedObjects  -Server $Server -Credential $Credential | ForEach-Object {
        @{
            distinguishedname = $_.DistinguishedName
            name = $_.Name
        }
    }
    New-UDTable -Data $DeletedUsers -Columns $Columns
}