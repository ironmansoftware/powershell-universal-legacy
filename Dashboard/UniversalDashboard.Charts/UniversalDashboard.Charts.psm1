
if ($Env:DebugCharts -eq $true) {
    $AssetId = [UniversalDashboard.Services.AssetService]::Instance.RegisterAsset("http://localhost:10000/udcharts.bundle.js")
    [UniversalDashboard.Enterprise.NewNivoChartCommand]::AssetId = $AssetId
} else {
    $JsFile = Get-ChildItem "$PSScriptRoot\udcharts.*.bundle.js"
    $AssetId = [UniversalDashboard.Services.AssetService]::Instance.RegisterAsset($JsFile.FullName)
    [UniversalDashboard.Enterprise.NewNivoChartCommand]::AssetId = $AssetId
}

function New-UDNivoTheme {
    param(
        [Parameter()]
        [UniversalDashboard.Models.DashboardColor]$TickLineColor,
        [Parameter()]
        [UniversalDashboard.Models.DashboardColor]$TickTextColor,
        [Parameter()]
        [UniversalDashboard.Models.DashboardColor]$GridLineStrokeColor,
        [Parameter()]
        [int]$GridStrokeWidth
    )

    @{
        axis = @{
            ticks = @{
                line = @{
                    stoke = $TickLineColor.HtmlColor
                }
                text = @{
                    fill = $TickTextColor.HtmlColor
                }
            }
        }
        grid = @{
            line = @{
                stroke = $GridLineStrokeColor.HtmlColor
                strokeWidth = $GridStrokeWidth
            }
        }
    }
}

function New-UDChartJS {
    param(
        [Parameter()]
        [string]$Id = [Guid]::NewGuid(),
        [Parameter(ParameterSetName = 'Simple')]
		[string]$DatasetLabel,
        [Parameter()]
        [ValidateSet('bar', 'line', 'area', 'doughnut', 'radar', 'pie', 'horizontalBar')]
		[string]$Type,
		[Parameter()]
		[Hashtable]$Options,
		[Parameter()]
        [Endpoint]$OnClick,
        [Parameter(Mandatory)]
		$Data,
		[Parameter(ParameterSetName = 'Datasets', Mandatory)]
		[Hashtable[]]$Dataset,
		[Parameter(ParameterSetName = "Simple", Mandatory)]
		[string]$DataProperty,
		[Parameter(Mandatory)]
		[string]$LabelProperty,
		[Parameter(ParameterSetName = "Simple")]
		[UniversalDashboard.Models.DashboardColor[]]$BackgroundColor = @("#808978FF"),
		[Parameter(ParameterSetName = "Simple")]
		[UniversalDashboard.Models.DashboardColor[]]$BorderColor = @("#FF8978FF"),
		[Parameter(ParameterSetName = "Simple")]
		[UniversalDashboard.Models.DashboardColor[]]$HoverBackgroundColor = @("#807B210C"),
		[Parameter(ParameterSetName = "Simple")]
		[UniversalDashboard.Models.DashboardColor[]]$HoverBorderColor = @("#FF7B210C")

    )

    if ($OnClick)
    {
        $OnClick.Register($Id, $PSCmdlet) | Out-Null
	}

	if ($PSCmdlet.ParameterSetName -eq 'Simple')
	{
		if (-not $DatasetLabel)
		{
			$DatasetLabel = $DataProperty
		}

		$Dataset += New-UDChartJSDataset -DataProperty $DataProperty -Label $DatasetLabel -BackgroundColor $BackgroundColor -BorderColor $BorderColor -HoverBackgroundColor $HoverBackgroundColor -HoverBorderColor $HoverBorderColor
	}
	
	Foreach($datasetDef in $Dataset) {
		$datasetDef.data = @($Data | ForEach-Object { $_.($datasetDef.DataProperty) })
	}



    @{
        type = 'ud-chartjs'
        id = $id 
        isPlugin = $true
        assetId = $AssetId
        chartType = $Type.ToLower()
        options = $Options
        onClick = $OnClick
        data = @{
			labels = @($Data | ForEach-Object { $_.($LabelProperty) })
			datasets = $dataset
		}
    }
}

function New-UDChartJSDataset {
	[CmdletBinding()]
	param(
		[string]$DataProperty,
		[string]$Label,
		[UniversalDashboard.Models.DashboardColor[]]$BackgroundColor = @("#807B210C"),
		[UniversalDashboard.Models.DashboardColor[]]$BorderColor = @("#FF7B210C"),
		[int]$BorderWidth,
		[UniversalDashboard.Models.DashboardColor[]]$HoverBackgroundColor = @("#807B210C"),
		[UniversalDashboard.Models.DashboardColor[]]$HoverBorderColor = @("#FF7B210C"),
		[int]$HoverBorderWidth,
		[string]$XAxisId,
		[string]$YAxisId,
		[Hashtable]$AdditionalOptions
	)

	Begin {
		$datasetOptions = @{
			data = @()
			DataProperty = $DataProperty
			label = $Label
			backgroundColor = $BackgroundColor.HtmlColor
			borderColor = $BorderColor.HtmlColor
			borderWidth = $BorderWidth
			hoverBackgroundColor = $HoverBackgroundColor.HtmlColor
			hoverBorderColor = $HoverBorderColor.HtmlColor
			hoverBorderWidth = $HoverBorderWidth
			xAxisId = $XAxisId
			yAxisId = $YAxisId
		}

		if ($AdditionalOptions) {
			$AdditionalOptions.GetEnumerator() | ForEach-Object {
				$datasetOptions.($_.Key) = $_.Value
			}
		}

		$datasetOptions
	}
}

function New-UDChartJSMonitor {
    param(
        [Parameter()]
        [string]$Id = [Guid]::NewGuid(),
        [Parameter()]
        [ValidateSet('bar', 'line', 'area', 'doughnut', 'radar', 'pie', 'horizontalBar')]
		[string]$Type = 'line',
		[Parameter()]
		[int]$DataPointHistory = 10,
		[Parameter()]
		[Hashtable]$Options,
		[Parameter()]
		[DashboardColor[]]$ChartBackgroundColor,
		[Parameter()]
		[DashboardColor[]]$ChartBorderColor,
		[Parameter(Mandatory)]
		[string[]]$Labels = @(),
        [Parameter()]
        [Switch]$AutoRefresh,
        [Parameter()]
        [int]$RefreshInterval = 5,
        [Parameter(Mandatory)]
        [Endpoint]$LoadData
    )

    $LoadData.Register($Id, $PSCmdlet) | Out-Null

    @{
        type = 'chartjs-monitor'
		id = $id 
		assetId = $AssetId
		isPlugin = $true
		
		loadData = $LoadData
        labels = $Labels
        dataPointHistory = $DataPointHistory
        chartType = $Type.ToLower()
        options = $Options
        autoRefresh = $AutoRefresh
        refreshInterval = $RefreshInterval 
        chartBackgroundColor = if($chartBackgroundColor) { $chartBackgroundColor.HtmlColor } else { @() }
        chartBorderColor = if ($ChartBorderColor) { $ChartBorderColor.HtmlColor } else { @() }
    }
}

function Out-UDChartJSMonitorData {
	[CmdletBinding()]
    param(
		[Parameter(ValueFromPipeline = $true)]
		$Data
	)

	Begin {
		New-Variable -Name Items -Value @()
	}

	Process {
		$Items += $Data
	}

	End {
		$Timestamp = [DateTime]::UtcNow
		$dataSets = @()
		foreach($item in $Items) {
			$dataSets += @{
				x = $Timestamp
				y = $item
			}
		}
		$dataSets | ConvertTo-Json
	}
}


function New-UDSparkline {
	param(
		[Parameter()]
		[string]$Id = [Guid]::NewGuid().ToString(),
		[Parameter(Mandatory)]
		[int[]]$Data, 
		[Parameter()]
		[int]$Limit, 
		[Parameter()]
		[int]$Width,
		[Parameter()]
		[int]$Height, 
		[Parameter()]
		[int]$Margin,
		[Parameter()]
		[DashboardColor]$Color,
		[Parameter()]
		[ValidateSet("bars", "lines", "both")]
		$Type = 'bars',
		[Parameter()]
		[int]$Min,
		[Parameter()]
		[int]$Max
	)

	@{
		type = 'sparklines'
		isPlugin = $true
		assetId = $AssetId
		id = $Id 
		data = $data 
		limit = $Limit 
		width = $Width 
		height = $Height 
		marin = $Margin 
		color = $Color.HtmlColor 
		sparkType = $Type
		min = $Min 
		max = $Max
	}
}