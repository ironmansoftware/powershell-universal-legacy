Import-Module "$PSScriptRoot\..\release.psm1"

Publish-PSUModule -ModuleName 'UniversalDashboard.HyperV' -SourceDirectory "$PSScriptRoot"