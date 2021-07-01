New-UDDashboard -Title "Hello, World!" -Content {
    $Data = Get-PSUCache -Key 'Processes'

    New-UDTable -Data $Data -Paging
}