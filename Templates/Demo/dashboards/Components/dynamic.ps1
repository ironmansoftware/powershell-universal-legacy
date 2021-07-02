New-UDPage -Name 'New-UDDynamic' -Content {
    New-UDTypography -Text 'Basic Dynamic Region' -Variant 'h4'
    
    New-UDDynamic -Id 'date' -Content {
        New-UDTypography -Text "$(Get-Date)"
    }

    New-UDButton -Text 'Reload Date' -OnClick { Sync-UDElement -Id 'date' }

    New-UDElement -Tag 'hr'

    New-UDTypography -Text 'Auto-Refresh' -Variant 'h4'

    New-UDDynamic -Id 'date' -Content {
        New-UDTypography -Text "$(Get-Date)"
        New-UDTypography -Text "$(Get-Random)"
    } -AutoRefresh -AutoRefreshInterval 1

    New-UDElement -Tag 'hr'

    New-UDTypography -Text 'Loading Component' -Variant 'h4'

    New-UDDynamic -Content {
        Start-Sleep -Seconds 10
        New-UDTypography -Text "Done!"
    } -LoadingComponent {
        New-UDProgress -Circular
    }
}