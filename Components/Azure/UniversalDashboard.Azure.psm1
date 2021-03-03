function New-UDAzureAppInsightsCounter {
    <#
    .SYNOPSIS
    Displays a card with a count of the custom events in Application Insights.
    
    .DESCRIPTION
    Displays a card with a count of the custom events in Application Insights.
    
    .PARAMETER ApiKey
    The API key used ot access the App Insights REST API.
    
    .PARAMETER ApplicationId
    The Application ID to access.
    
    .PARAMETER CustomEventName
    The custom event name to count.
    
    .PARAMETER TimeSpan
    The time span to look back for events. Defaults to 7 days.
    
    .PARAMETER Title
    The title of the card to create.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$ApiKey, 
        [Parameter(Mandatory)]
        [string]$ApplicationId,
        [Parameter(Mandatory)]
        [string]$CustomEventName,
        [Parameter()]
        [TimeSpan]$TimeSpan = [TimeSpan]::FromDays(7),
        [Parameter()]
        [string]$Title
    )

    $ts = [System.Xml.XmlConvert]::ToString($TimeSpan)

    $Headers = @{
        'x-api-key' = $ApiKey
    }
    $url = "https://api.applicationinsights.io/v1/apps/$ApplicationId/events/customEvents?timespan=$ts&`$search=$CustomEventName&`$top=1&`$count=true"


    $Data = (Invoke-RestMethod -Uri $Url -Headers $Headers)

    $Count = $Data.'@odata.count'

    New-UDCard -Content {
        New-UDTypography $Count -variant h2
    } -Title $Title
}