
$Navigation = @(
    New-UDListItem -Label "Group Membership" -OnClick { Invoke-UDRedirect '/Groups' }
    New-UDListItem -Label "Reset Password" -OnClick { Invoke-UDRedirect '/Reset-Password' }
    New-UDListItem -Label "Restore Deleted User" -OnClick { Invoke-UDRedirect '/Restore-Deleted-User' }
    New-UDListItem -Label "Object Search" -OnClick { Invoke-UDRedirect '/Object-Search' }
)

New-UDDashboard -Title "Active Directory Tools" -Pages @(
  . "$PSScriptRoot\pages\group-membership.ps1"
  . "$PSScriptRoot\pages\password-reset.ps1"
  . "$PSScriptRoot\pages\restore-deleted-user.ps1"
  . "$PSScriptRoot\pages\object-search.ps1"
  . "$PSScriptRoot\pages\object-info.ps1"
) 