
$IndexJs = Get-ChildItem "$PSScriptRoot\index.*.bundle.js"
$JsFiles = Get-ChildItem "$PSScriptRoot\*.bundle.js"
$Maps = Get-ChildItem "$PSScriptRoot\*.map"

$AssetId = [UniversalDashboard.Services.AssetService]::Instance.RegisterScript($IndexJs.FullName)

foreach($item in $JsFiles)
{
    [UniversalDashboard.Services.AssetService]::Instance.RegisterScript($item.FullName) | Out-Null
}

foreach($item in $Maps)
{
    [UniversalDashboard.Services.AssetService]::Instance.RegisterScript($item.FullName) | Out-Null
}

function New-UDStyle {
    param(
        [Parameter()]
        [string]$Id = (New-Guid).ToString(),
        [Parameter(Mandatory = $true)]
        [string]$Style,
        [Parameter()]
        [string]$Tag = 'div',
        [Parameter()]
        [ScriptBlock]$Content
    )

    End {

        $Children = $null
        if ($null -ne $Content)
        {
            $Children = & $Content
        }

        @{
            assetId = $AssetId 
            isPlugin = $true 
            type = "ud-style"
            id = $Id
            style = $Style
            tag = $Tag
            content = $Children
        }
    }
}