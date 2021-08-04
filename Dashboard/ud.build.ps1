$OutputPath = "$PSScriptRoot\..\output"

task Build {
    . "$PSScriptRoot\UniversalDashboard.Monaco\build.ps1"
    Invoke-Build -File "$PSScriptRoot\UniversalDashboard.Charts\build.ps1"
    Invoke-Build -File "$PSScriptRoot\UniversalDashboard.Map\build.ps1"
    Invoke-Build -File "$PSScriptRoot\UniversalDashboard.Style\build.ps1"
    Invoke-Build -File "$PSScriptRoot\v2\build.ps1"
    Invoke-Build -File "$PSScriptRoot\v3\build.ps1"
}

task . Build