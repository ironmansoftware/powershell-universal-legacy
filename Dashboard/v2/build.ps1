task Stage {
    Push-Location "$PSScriptRoot"
    Copy-Item "$PSScriptRoot\UniversalDashboard.Materialize.psm1" "$PSScriptRoot\output\UniversalDashboard.Materialize.psm1" -Force
    Get-ChildItem "$PSScriptRoot\Scripts" -File -Recurse -Filter "*.ps1" | ForEach-Object {
        Get-Content $_.FullName -Raw | Out-File "$PSScriptRoot\output\UniversalDashboard.Materialize.psm1" -Append -Encoding UTF8
    }
    Copy-Item "$PSScriptRoot\themes" "$PSScriptRoot\output\Themes" -Container -Recurse
    Copy-Item "$PSScriptRoot\UniversalDashboard.psd1" "$PSScriptRoot\output" 
    Copy-Item "$PSScriptRoot\example.ps1" "$PSScriptRoot\output" 

    Pop-Location
}

task Build {
    Remove-Item "$PSScriptRoot\output" -Recurse -Force -ErrorAction SilentlyContinue
    Push-Location "$PSScriptRoot"
    & {
        $ErrorActionPreference = 'SilentlyContinue'
        npm install --silent 
        npm run build --silent 
    }
    Pop-Location
}

task . Build, Stage