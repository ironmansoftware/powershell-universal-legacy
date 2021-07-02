New-UDPage -Name 'New-UDChartJS' -Content {
    New-UDTypography -Text 'Bar Chart' -Variant 'h4'

    $Data = Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 
    New-UDChartJS -Type 'bar' -Data $Data -DataProperty CPU -LabelProperty ProcessName -BackgroundColor "#228e20"

    New-UDTypography -Text 'Stacked Bar Chart' -Variant 'h4'

    $GraphPrep = @(
        @{ RAM = "Server1"; AvailableRam = 128; UsedRAM = 10 }
        @{ RAM = "Server2"; AvailableRam = 64; UsedRAM = 63 }
        @{ RAM = "Server3"; AvailableRam = 48; UsedRAM = 40 }
        @{ RAM = "Server4"; AvailableRam = 64;; UsedRAM = 26 }
        @{ RAM = "Server5"; AvailableRam = 128; UsedRAM = 120 }
    )

    $AvailableRamDataSet = New-UDChartJSDataset -DataProperty AvailableRAM -Label 'Available' -BackgroundColor blue
    $UsedRamDataset = New-UDChartJSDataset -DataProperty UsedRAM -Label 'Used' -BackgroundColor red
    $Options = @{
        Type          = 'bar'
        Data          = $GraphPrep
        Dataset       = @($AvailableRamDataSet, $UsedRamDataset)
        LabelProperty = "RAM"
        Options = @{
            scales = @{
                xAxes = @(
                @{
                    stacked = $true
                }
            )
            yAxes = @(
                @{
                    stacked = $true
                }
            )
            }
        }
    } 

    New-UDChartJS @Options

    New-UDTypography -Text 'Horizontal Bar Chart' -Variant 'h4'

    $Data = Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 
    New-UDChartJS -Type 'horizontalBar' -Data $Data -DataProperty CPU -LabelProperty ProcessName

    New-UDTypography -Text 'Line Chart' -Variant 'h4'

    $Data = Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 
    New-UDChartJS -Type 'line' -Data $Data -DataProperty CPU -LabelProperty ProcessName

    New-UDTypography -Text 'Doughnut Chart' -Variant 'h4'

    $Data = Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 
    New-UDChartJS -Type 'doughnut' -Data $Data -DataProperty CPU -LabelProperty ProcessName

    New-UDTypography -Text 'Pie Chart' -Variant 'h4'

    $Data = Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 
    New-UDChartJS -Type 'pie' -Data $Data -DataProperty CPU -LabelProperty ProcessName

    New-UDTypography -Text 'Radar Chart' -Variant 'h4'

    $Data = Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 
    New-UDChartJS -Type 'radar' -Data $Data -DataProperty CPU -LabelProperty ProcessName

    New-UDTypography -Text 'Data Sets' -Variant 'h4'

    $Data = Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 

    $CPUDataset = New-UDChartJSDataset -DataProperty CPU -Label CPU -BackgroundColor '#126f8c'
    $MemoryDataset = New-UDChartJSDataset -DataProperty HandleCount -Label 'Handle Count' -BackgroundColor '#8da322'

    $Options = @{
        Type = 'bar'
        Data = $Data
        Dataset = @($CPUDataset, $MemoryDataset)
        LabelProperty = "ProcessName"
    }

    New-UDChartJS @Options

    New-UDTypography -Text 'Click Events' -Variant 'h4'

    $Data = Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 

    $Options = @{
     Type = 'bar'
     Data = $Data
     DataProperty = 'CPU'
     LabelProperty = "ProcessName"
     OnClick = { 
        Show-UDToast -Message $Body
     }
   }
  
  
   New-UDChartJS @Options

   New-UDTypography -Text 'Auto refreshing charts' -Variant 'h4'

   New-UDDynamic -Content {
        $Data = 1..10 | % { 
            [PSCustomObject]@{ Name = $_; value = get-random }
        }
        New-UDChartJS -Type 'bar' -Data $Data -DataProperty Value -Id 'test' -LabelProperty Name -BackgroundColor Blue
    } -AutoRefresh -AutoRefreshInterval 1

    New-UDTypography -Text 'Monitors' -Variant 'h4'

    New-UDChartJSMonitor -LoadData {
        Get-Random -Max 100 | Out-UDChartJSMonitorData
    } -Labels "Random" -ChartBackgroundColor "#297741" -RefreshInterval 1
}