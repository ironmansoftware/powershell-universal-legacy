Import-Module "$PSScriptRoot\..\release.psm1"

Publish-PSUModule -ModuleName 'UniversalDashboard.ActiveDirectory' -SourceDirectory "$PSScriptRoot"