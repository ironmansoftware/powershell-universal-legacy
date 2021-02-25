Import-Module "$PSScriptRoot\..\release.psm1"

Publish-PSUModule -ModuleName 'UniversalDashboard.Monitoring' -SourceDirectory "$PSScriptRoot"