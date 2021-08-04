function New-UDDashboard
{
    <#
    .SYNOPSIS
    Creates a new dashboard.
    
    .DESCRIPTION
    Creates a new dashboard. This component is the root element for all dashboards. You can define content, pages, themes and more.
    
    .PARAMETER Title
    The title of the dashboard.
    
    .PARAMETER Content
    The content for this dashboard. When using content, it creates a dashboard with a single page.
    
    .PARAMETER Pages
    Pages for this dashboard. Use New-UDPage to define a page and pass an array of pages to this parameter. 
    
    .PARAMETER Theme
    The theme for this dashboard. You can define a theme with New-UDTheme. 
    
    .PARAMETER Scripts
    JavaScript files to run when this dashboard is loaded. These JavaScript files can be absolute and hosted in a third-party CDN or you can host them yourself with New-PSUPublishedFolder.
    
    .PARAMETER Stylesheets
    CSS files to run when this dashboard is loaded. These CSS files can be absolute and hosted in a third-party CDN or you can host them yourself with New-PSUPublishedFolder.
    
    .PARAMETER Logo
    A logo to display in the navigation bar. You can use New-PSUPublishedFolder to host this logo file.
    
    .PARAMETER DefaultTheme
    The default theme to show when the page is loaded. The default is to use the light theme. 
    
    .EXAMPLE
    Creates a new dashboard with a single page.

    New-UDDashboard -Title 'My Dashboard' -Content {
        New-UDTypography -Text 'Hello, world!'
    }

    .EXAMPLE
    Creates a new dashboard with multiple pages.

    $Pages = @(
        New-UDPage -Name 'HomePage' -Content {
            New-UDTypography -Text 'Home Page'
        }
        New-UDPage -Name 'Page2' -Content {
            New-UDTypography -Text 'Page2'
        }
    )

    New-UDDashboard -Title 'My Dashboard' -Pages $Pages
    
    #>
    param(
        [Parameter()]
        [string]$Title = "PowerShell Universal Dashboard",
        [Parameter(ParameterSetName = "Content", Mandatory)]
        [Endpoint]$Content,
        [Parameter(ParameterSetName = "Pages", Mandatory)]
        [Hashtable[]]$Pages = @(),
        [Parameter()]
        [Hashtable]$Theme = @{},
        [Parameter()]
        [string[]]$Scripts = @(),
        [Parameter()]
        [string[]]$Stylesheets = @(),
        [Parameter()]
        [string]$Logo,
        [Parameter()]
        [ValidateSet("Light", "Dark")]
        [string]$DefaultTheme = "Light",
        [Parameter()]
        [switch]$DisableThemeToggle
    )    

    if ($PSCmdlet.ParameterSetName -eq 'Content')
    {
        $Pages += New-UDPage -Name 'Home' -Content $Content -Logo $Logo
    }

    $Cache:Pages = $Pages

    @{
        title = $Title 
        pages = $Pages
        theme = $Theme
        scripts = $Scripts
        stylesheets = $Stylesheets
        defaultTheme = $DefaultTheme.ToLower()
        disableThemeToggle = $DisableThemeToggle.IsPresent
    }
}
