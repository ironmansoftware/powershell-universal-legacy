task Stage {
    Push-Location "$PSScriptRoot"
    Copy-Item "$PSScriptRoot\UniversalDashboard.MaterialUI.psm1" "$PSScriptRoot\output\UniversalDashboard.MaterialUI.psm1" -Force
    Get-ChildItem "$PSScriptRoot\Scripts" -File -Recurse -Filter "*.ps1" | ForEach-Object {
        Get-Content $_.FullName -Raw | Out-File "$PSScriptRoot\output\UniversalDashboard.MaterialUI.psm1" -Append -Encoding UTF8
    }
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

task FontAwesomeIconList {
    $ScriptRoot = $PSScriptRoot

    Remove-Item "$PSScriptRoot\output\fontawesome.brands.txt" -ErrorAction SilentlyContinue
    Remove-Item "$PSScriptRoot\output\fontawesome.regular.txt" -ErrorAction SilentlyContinue
    Remove-Item "$PSScriptRoot\output\fontawesome.solid.txt" -ErrorAction SilentlyContinue

    function Out-FontFile {
        param($InputFolder, $OutputFile)

        $sb = [System.Text.StringBuilder]::new()
        Get-ChildItem $InputFolder | ForEach-Object {
            if ($_.Name -ne 'index.js' -and $_.Name -ne 'index.es.js') { 
                $sb.AppendLine($_.Name.Replace('.js', '').Substring(2).Trim()) | Out-Null
            }
        }
    
        $sb.ToString() | Out-File $OutputFile
    }

    Out-FontFile -InputFolder "$ScriptRoot\node_modules\@fortawesome\free-brands-svg-icons\*.js" -OutputFile "$ScriptRoot\output\fontawesome.brands.txt"
    Out-FontFile -InputFolder "$ScriptRoot\node_modules\@fortawesome\free-regular-svg-icons\*.js" -OutputFile "$ScriptRoot\output\fontawesome.regular.txt"
    Out-FontFile -InputFolder "$ScriptRoot\node_modules\@fortawesome\free-solid-svg-icons\*.js" -OutputFile "$ScriptRoot\output\fontawesome.solid.txt"
}

task . Build, Stage, FontAwesomeIconList