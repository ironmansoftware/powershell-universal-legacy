Import-Module "$PSScriptRoot\..\release.psm1"

Publish-PSUModule -ModuleName 'UniversalDashboard.Network' -SourceDirectory "$PSScriptRoot"