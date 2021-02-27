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
