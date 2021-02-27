Import-Module "$PSScriptRoot\..\release.psm1"

Publish-PSUModule -ModuleName 'UniversalDashboard.Windows' -SourceDirectory "$PSScriptRoot"