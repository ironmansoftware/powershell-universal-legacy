Import-Module "$PSScriptRoot\..\release.psm1"

Publish-PSUModule -ModuleName 'UniversalDashboard.SQL' -SourceDirectory "$PSScriptRoot"