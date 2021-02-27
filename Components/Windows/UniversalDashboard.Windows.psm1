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
        New-UDSkeleton 
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