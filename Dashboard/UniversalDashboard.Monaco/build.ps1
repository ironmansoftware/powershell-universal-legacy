$BuildFolder = $PSScriptRoot

$powerShellGet = Import-Module PowerShellGet  -PassThru -ErrorAction Ignore
if ($powerShellGet.Version -lt ([Version]'1.6.0')) {
	Install-Module PowerShellGet -Scope CurrentUser -Force -AllowClobber
	Import-Module PowerShellGet -Force
}

Set-Location $BuildFolder

$OutputPath = "$BuildFolder\output"

Remove-Item -Path $OutputPath -Force -ErrorAction SilentlyContinue -Recurse
Remove-Item -Path "$BuildFolder\public" -Force -ErrorAction SilentlyContinue -Recurse

New-Item -Path $OutputPath -ItemType Directory

& {
	$ErrorActionPreference = 'SilentlyContinue'
	npm install --silent 
	npm run build --silent 
}

Copy-Item $BuildFolder\public\*.* $OutputPath
Copy-Item $BuildFolder\UniversalDashboard.CodeEditor.psm1 $OutputPath

$Version = "1.1.1"

$manifestParameters = @{
	Path = "$OutputPath\UniversalDashboard.CodeEditor.psd1"
	Author = "Adam Driscoll"
	CompanyName = "Ironman Software, LLC"
	Copyright = "2020 Ironman Software, LLC"
	RootModule = "UniversalDashboard.CodeEditor.psm1"
	Description = "Code editor control for Universal Dashboard."
	ModuleVersion = $version
	Tags = @("universaldashboard", "monaco", 'code', 'ud-control')
	ReleaseNotes = "Open sourced control."
	FunctionsToExport = @(
		"New-UDCodeEditor"
	)
	RequiredModules = @('UniversalDashboard')
	ProjectUri = "https://github.com/ironmansoftware/universal-dashboard"
	IconUri = 'https://raw.githubusercontent.com/ironmansoftware/universal-dashboard/master/images/logo.png'
}

New-ModuleManifest @manifestParameters

if ($prerelease -ne $null) {
	Update-ModuleManifest -Path "$OutputPath\UniversalDashboard.CodeEditor.psd1" -Prerelease $prerelease
}