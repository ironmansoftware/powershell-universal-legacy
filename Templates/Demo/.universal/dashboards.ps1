﻿New-PSUDashboard -Name "ComputerInfo" -FilePath "dashboards\ComputerInfo\ComputerInfo.ps1" -BaseUrl "/dashboard" -Framework "UniversalDashboard:Latest" -SessionTimeout 0 -Credential "Default" 
New-PSUDashboard -Name "Components" -FilePath "dashboards\Components\Components.ps1" -BaseUrl "/components" -Framework "UniversalDashboard:Latest" -Component @("UniversalDashboard.Charts:1.3.2", "UniversalDashboard.Map:1.0") -SessionTimeout 0 -Description "Example of components of PowerShell Universal Dashboard" -Credential "Default" 
New-PSUDashboard -Name "CSV Editor" -FilePath "dashboards\CSV Editor\CSV Editor.ps1" -BaseUrl "/csv-editor" -Framework "UniversalDashboard:Latest" -SessionTimeout 0 -AutoDeploy