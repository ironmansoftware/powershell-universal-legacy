$Pages = @()

$Pages += . "$PSScriptRoot\chartjs.ps1"
$Pages += . "$PSScriptRoot\dynamic.ps1"
$Pages += . "$PSScriptRoot\element.ps1"
$Pages += . "$PSScriptRoot\form.ps1"
$Pages += . "$PSScriptRoot\map.ps1"
$Pages += . "$PSScriptRoot\nivo.ps1"
$Pages += . "$PSScriptRoot\table.ps1"

New-UDDashboard -Title "Components" -Pages $Pages