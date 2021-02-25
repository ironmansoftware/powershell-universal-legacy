function New-UDPerformanceCounterGraph {
    <#
    .SYNOPSIS
    Creates a performance counter graph based on the specified counter.
    
    .DESCRIPTION
    Creates a performance counter graph based on the specified counter.
    
    .PARAMETER Counter
    The name of the performance counter.
    
    .EXAMPLE
    New-UDPerformanceCounterGraph -Counter '\Network Adapter(*)\Bytes Total/sec'
    #>
    param($Counter)
      New-UDTypography -Text $Counter
      New-UDChartJSMonitor -LoadData {
          $Value = 0 
          try {
              $Value = (Get-Counter -Counter $Counter -ErrorAction SilentlyContinue).CounterSamples[0].CookedValue
          } catch {}
          $Value | Out-UDChartJSMonitorData
      } -Labels "Value" -ChartBackgroundColor "#297741" -RefreshInterval 3 -DataPointHistory 10
  }