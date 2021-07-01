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
        [string]$Server = $ActiveDirectoryServer,
        [PSCredential]$Credential = $ActiveDirectoryCredential
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

New-UDDashboard -Title "Password Reset" -Content {
    New-UDADPasswordResetForm
}