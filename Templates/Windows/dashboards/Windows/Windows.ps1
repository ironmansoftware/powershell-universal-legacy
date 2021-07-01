function New-UDServiceTable 
{
    <#
    .SYNOPSIS
    Creates a table that displays service status.
    
    .DESCRIPTION
    Creates a table that displays service status. Services can be started and stopped.
    
    .EXAMPLE
    New-UDServiceTable
    #>
    $Columns = @(
        New-UDTableColumn -Title 'Name' -Property 'Name'
        New-UDTableColumn -Title 'Description' -Property 'Description'
        New-UDTableColumn -Title 'Status' -Property 'Status'
        New-UDTableColumn -Title 'Actions' -Property 'Actions' -Render {
            if ($EventData.Status -eq 'Running')
            {
                New-UDButton -Text "Stop" -OnClick { 
                    try 
                    {
                        Stop-Service $EventData.Name -ErrorAction stop
                        Show-UDToast -Message "Stopping service $($EventData.Name)"
                        Sync-UDElement -Id 'serviceTable'
                    }
                    catch 
                    {
                        Show-UDToast -Message "Failed to stop service. $_" -BackgroundColor 'red' -Duration 5000 -MessageColor 'white'
                    }
                } -Icon (New-UDIcon -Icon stop)
            }
            else
            {
                New-UDButton -Text "Start" -OnClick { 
                    try
                    {
                        Start-Service $EventData.Name -ErrorAction stop
                        Show-UDToast -Message "Starting service $($EventData.Name)"
                        Sync-UDElement -Id 'serviceTable'
                    }
                    catch
                    {
                        Show-UDToast -Message "Failed to start service. $_" -BackgroundColor 'red' -Duration 5000 -MessageColor 'white'

                    }

                } -Icon (New-UDIcon -Icon play)
            }
            
        }
    )

    New-UDDynamic -Id 'serviceTable' -Content {
        $Services = Get-Service 
        New-UDTable -Columns $Columns -Data $Services -Paging -Sort
    } -LoadingComponent {
        New-UDProgress -Circular
    }
}

function ConvertTo-ByteString {
    param(
        [Parameter(ValueFromPipeline = $true)]
        $byteCount
    )

    Process {
        $suf = @( "B", "KB", "MB", "GB", "TB", "PB", "EB" )
        if ($byteCount -eq 0)
        {
            return "0" + $suf[0];
        }
            
        $bytes = [Math]::Abs($byteCount);
        $place = [Convert]::ToInt32([Math]::Floor([Math]::Log($bytes, 1024)))
        $num = [Math]::Round($bytes / [Math]::Pow(1024, $place), 1)
        return ([Math]::Sign($byteCount) * $num).ToString() + $suf[$place]
    }

}

function New-UDProcessTable 
{
    <#
    .SYNOPSIS
    Creates a table that displays process information.
    
    .DESCRIPTION
    Creates a table that displays process information. The table is has pagination enabled and can be sorted and searched.
    
    .EXAMPLE
    New-UDProcessTable
    #>
    $Columns = @(
        New-UDTableColumn -Title 'Id' -Property 'ID'
        New-UDTableColumn -Title 'Name' -Property 'ProcessName'
        New-UDTableColumn -Title 'CPU' -Property 'CPU'
        New-UDTableColumn -Title 'WorkingSet' -Property 'WorkingSet' -Render {
            $EventData.WorkingSet | ConvertTo-ByteString
        }
    )
    $Processes = Get-Process | Select-Object @("Id", "ProcessName", "CPU", "WorkingSet")
    New-UDTable -Columns $Columns -Data $Processes -Paging -Sort -Search
}

function New-UDEventLogTable {
    <#
    .SYNOPSIS
    Creates a Windows Event Log table.
    
    .DESCRIPTION
    Creates a Windows Event Log table.
    
    .EXAMPLE
    New-UDEventLogTable
    
    Creates a Windows Event Log table.
    #>
    $Columns = @(
        New-UDTableColumn -Property EntryType -Title "Level" -ShowFilter -FilterType select
        New-UDTableColumn -Property TimeWritten -Title "Date and Time"
        New-UDTableColumn -Property Source -Title "Source"  -ShowFilter -FilterType select
        New-UDTableColumn -Property EventId -Title "EventId" -ShowFilter 
        New-UDTableColumn -Property Category -Title "Category"
        New-UDTableColumn -Property Message -Title "Message" -Truncate -Width 400 -ShowFilter 
        New-UDTableColumn -Property Action -Title "" -Render {
            New-UDButton -Text 'View Message' -OnClick {
                Show-UDModal -Content {
                    $EventData.message
                }
            }
        }
    )

    $Sources = Get-WmiObject -Class Win32_NTEventLOgFile | 
        Select-Object FileName, Sources | 
        ForEach-Object -Begin { $hash = @{}} -Process { $hash[$_.FileName] = $_.Sources } -end { $Hash }

    New-UDSelect -Option {
        $Sources.Keys | Sort-Object | ForEach-Object {
            New-UDSelectOption -Name $_ -Value $_
        }
    } -OnChange {
        $Session:LogName = $EventData
        Sync-UDElement -Id 'eventLogTable'
    }

    New-UDDynamic -Id 'eventLogTable' -Content {
        if ($null -eq $Session:LogName)
        {
            $Session:LogName = "Application"
        }

        $Data = Get-EventLog -Newest 100 -LogName $Session:LogName | Select-Object EntryType, TimeWritten, Source, EventId, Category, Message
        New-UDTable -Data $Data -Columns $Columns -ShowSort -ShowFilter
    } -LoadingComponent {
        New-UDProgress -Circular
    }
}

New-UDDashboard -Title "Windows" -Pages @(
    New-UDPage -Name 'Dashboard' -Content {

        New-UDTypography -Variant h5 -Text $ENV:ComputerName
        $ComputerInfo = Get-ComputerInfo
        New-UDTypography -Variant h5 -Text "Operating System: $($ComputerInfo.WindowsProductName)" 
        New-UDTypography -Variant h5 -Text "System Family: $($ComputerInfo.CsSystemFamily)" 
        New-UDTypography -Variant h5 -Text "Uptime: $($ComputerInfo.OsUptime)" 

        New-UDTypography -variant h3 -Text "Disks"
        New-UDRow -Columns {
            
            Get-Volume | ForEach-Object {
                New-UDColumn -Size 6 -LargeSize 6 -Content {
                    New-UDCard -Title "$($_.FileSystemLabel) ($($_.DriveLetter))" -Content {
                        $Data = @(
                            @{ Label = "Free Space"; Value = $_.SizeRemaining }
                            @{ Label = "Used Space"; Value = $_.Size - $_.SizeRemaining }
                        )
                        
                        New-UDChartJS -Type doughnut -Data $Data -LabelProperty 'Label' -DataProperty Value -BackgroundColor @("#0865dd", '#1f5ba8')           
                    }
                }
            }
        }
        New-UDTypography -variant h3 -Text "Network"
        New-UDRow -Columns {
            New-UDColumn -LargeSize 12 -Content {
                New-UDCard -Content {
                    $ReceivedDataSet = New-UDChartJSDataset -DataProperty ReceivedBytes -Label 'Received Bytes' -BackgroundColor '#1d2d8e'
                    $SentDataset = New-UDChartJSDataset -DataProperty SentBytes -Label 'Sent Bytes' -BackgroundColor '#6877d8'
                    $Options = @{
                        Type          = 'bar'
                        Data          = (Get-NetAdapterStatistics)
                        Dataset       = @($ReceivedDataSet, $SentDataset)
                        LabelProperty = "Name"
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
                }
            }
        }
        New-UDTypography -Variant h3 -Text "Temperatures (F)"

        New-UDRow -Columns {
            New-UDColumn -LargeSize 12 -Content {
                $temps = Get-WMIObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
                $temps = $temps | Select-Object -Property InstanceName,@{n="Temp";e={(($_.currenttemperature /10 -273.15) *1.8 +32)}}

                New-UDChartJS -Type 'bar' -Data $temps -DataProperty Temp -LabelProperty InstanceName -BackgroundColor '#dd5308'
            }
        }
    }
    New-UDPage -Name 'Services' -Content { 
        New-UDServiceTable 
    }
    New-UDPage -Name 'Processes' -Content { 
        New-UDProcessTable 
    }
    New-UDPage -Name 'Event Log' -Content { 
        New-UDEventLogTable
    }
)