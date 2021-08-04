function Set-UDElement
{
    param(
        [Parameter(Mandatory)]
        [string]$Id,
        [Alias("Attributes")]
        [Parameter()]
        [Hashtable]$Properties,
        [Parameter()]
        [Switch]$Broadcast,
        [Parameter()]
        [ScriptBlock]$Content
    )

    if ($Content -and -not $Properties)
    {
        $Properties = @{}
    }

    if ($Content)
    {
        $Properties['content'] = [Array](& $Content)
    }

    $Data = @{
        componentId = $Id 
        state = $Properties
    }

    if ($Broadcast)
    {
        $DashboardHub.SendWebSocketMessage("setState", $data)
    }
    else
    {
        $DashboardHub.SendWebSocketMessage($ConnectionId, "setState", $Data)
    }
}