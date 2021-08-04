function ConvertTo-FlatObject {
    param(
        [Parameter(Mandatory, ValueFromPipeline = $true)]
        $InputObject
    )

    Process {
        $OutputObject = @{}

        if ($InputObject -is [Hashtable])
        {
            foreach($key in $InputObject.Keys)
            {
                if ($key -and $key.StartsWith('rendered')) 
                { 
                    $OutputObject[$key] = $InputObject[$key]
                }
                else 
                {
                    $Value = $InputObject[$key]
                    if ($Value -is [DateTime])
                    {
                        $OutputObject[$key] = $Value
                    }
                    else
                    {
                        $OutputObject[$key] = if ($Value) { $Value.ToString() } else { "" } 
                    }
                    
                } 
            }
            [PSCustomObject]$OutputObject
        }
        else 
        {
            $InputObject | Get-Member -MemberType Properties | ForEach-Object {
                if ($_.Name -and $_.Name.StartsWith('rendered')) { 
                    $OutputObject[$_.Name] = $InputObject."$($_.Name)"
                }
                else 
                {
                    $Value = $InputObject."$($_.Name)"
                    if ($Value -is [DateTime])
                    {
                        $OutputObject[$_.Name] = $Value
                    }
                    else
                    {
                        $OutputObject[$_.Name] = if ($Value) { $Value.ToString() } else { "" } 
                    }
                } 
            }
            [PSCustomObject]$OutputObject
        }
    }
}

function New-UDTable {
    <#
    .SYNOPSIS
    Creates a table. 
    
    .DESCRIPTION
    Creates a table. Tables are used to show both static and dynamic data. You can define columns and data to show within the table. The columns can be used to render custom components based on row data. You can also enable paging, filtering, sorting and even server-side processing.
    
    .PARAMETER Id
    The ID of the component. It defaults to a random GUID.
    
    .PARAMETER Title
    The title to show at the top of the table's card. 
    
    .PARAMETER Data
    The data to put into the table. 
    
    .PARAMETER LoadData
    When using dynamic tables, this script block is called. The $Body parameter will contain a hashtable the following options: 
 
    filters: @()
    orderBy: string
    orderDirection: string
    page: int
    pageSize: int
    properties: @()
    search: string
    totalCount: int

    You can use these values to perform server-side processing, like SQL queries, to improve the performance of large grids. 

    After processing the data with these values, output the data via Out-UDTableData.  
            
    .PARAMETER Columns
    Defines the columns to show within the table. Use New-UDTableColumn to define these columns. If this parameter isn't specified, the properties of the data that you pass in will become the columns.
    
    .PARAMETER Sort
    Whether sorting is enabled in the table. 
    
    .PARAMETER Filter
    Whether filtering is enabled in the table. 
    
    .PARAMETER Search
    Whether search is enabled in the table. 
    
    .PARAMETER Export
    Whether exporting is enabled within the table. 

    .PARAMETER Icon
    Sets an icon next to the title. Use New-UDIcon to create the icon.
    
    .EXAMPLE
    Creates a static table whether the columns of the table are the properties of the data specified. 

    $Data = @(
        @{Dessert = 'Frozen yoghurt'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Ice cream sandwich'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Eclair'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Cupcake'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Gingerbread'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
    ) 

    New-UDTable -Id 'defaultTable' -Data $Data

    .EXAMPLE 
    Creates a table where there are custom columns defined for that table. 

     $Columns = @(
        New-UDTableColumn -Property Dessert -Title "A Dessert"
        New-UDTableColumn -Property Calories -Title Calories 
        New-UDTableColumn -Property Fat -Title Fat 
        New-UDTableColumn -Property Carbs -Title Carbs 
        New-UDTableColumn -Property Protein -Title Protein 
    )

    New-UDTable -Id 'customColumnsTable' -Data $Data -Columns $Columns

    .EXAMPLE
    Creates a table where the table has custom rendering for one of the columns and an export button. 

    $Columns = @(
        New-UDTableColumn -Property Dessert -Title Dessert -Render { 
            $Item = $Body | ConvertFrom-Json 
            New-UDButton -Id "btn$($Item.Dessert)" -Text "Click for Dessert!" -OnClick { Show-UDToast -Message $Item.Dessert } 
        }
        New-UDTableColumn -Property Calories -Title Calories 
        New-UDTableColumn -Property Fat -Title Fat 
        New-UDTableColumn -Property Carbs -Title Carbs 
        New-UDTableColumn -Property Protein -Title Protein 
    )

    New-UDTable -Id 'customColumnsTableRender' -Data $Data -Columns $Columns -Sort -Export

    .EXAMPLE
    Creates a table within a New-UDDynamic that refreshes automatically on an interval. 

    New-UDDynamic -Content {
        $DynamicData = @(
            @{Dessert = 'Frozen yoghurt'; Calories = (Get-Random); Fat = 6.0; Carbs = 24; Protein = 4.0}
            @{Dessert = 'Ice cream sandwich'; Calories = (Get-Random); Fat = 6.0; Carbs = 24; Protein = 4.0}
            @{Dessert = 'Eclair'; Calories = (Get-Random); Fat = 6.0; Carbs = 24; Protein = 4.0}
            @{Dessert = 'Cupcake'; Calories = (Get-Random); Fat = 6.0; Carbs = 24; Protein = 4.0}
            @{Dessert = 'Gingerbread'; Calories = (Get-Random); Fat = 6.0; Carbs = 24; Protein = 4.0}
        ) 

        New-UDTable -Id 'dynamicTable' -Data $DynamicData
    } -AutoRefresh -AutoRefreshInterval 2

    .EXAMPLE
    Creates a table that uses the LoadData script block to load data dynamically. 
    
    New-UDTable -Id 'loadDataTable' -Columns $Columns -LoadData {
    $Query = $Body | ConvertFrom-Json

    @(
        @{Dessert = 'Frozen yoghurt'; Calories = (Get-Random); Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Ice cream sandwich'; Calories = (Get-Random); Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Eclair'; Calories = (Get-Random); Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Cupcake'; Calories = (Get-Random); Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Gingerbread'; Calories = (Get-Random); Fat = 6.0; Carbs = 24; Protein = 4.0}
    ) | Out-UDTableData -Page 0 -TotalCount 5 -Properties $Query.Properties 
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Id = [Guid]::NewGuid().ToString(),
        [Parameter()]
        [string]$Title = "",
        [Parameter(Mandatory, ParameterSetName = "Static")]
        [AllowEmptyCollection()]
        [object[]]$Data,
        [Parameter(Mandatory, ParameterSetName = "Dynamic")]
        [Endpoint]$LoadData,
        [Parameter(ParameterSetName = "Static")]
        [Parameter(Mandatory, ParameterSetName = "Dynamic")]
        [Hashtable[]]$Columns,
        [Parameter()]
        [Endpoint]$OnRowSelection,
        [Parameter()]
        [Alias("Sort")]
        [Switch]$ShowSort,
        [Parameter()]
        [Alias("Filter")]
        [Switch]$ShowFilter,
        [Parameter()]
        [Alias("Search")]
        [Switch]$ShowSearch,
        [Parameter()]
        [Switch]$Dense,
        [Parameter()]
        [Alias("Export")]
        [Switch]$ShowExport,
        [Parameter()]
        [Switch]$StickyHeader,
        [Parameter()]
        [int]$PageSize = 5,
        [Parameter()]
        [int[]]$PageSizeOptions = @(),
        [Parameter()]
        [Alias("Select")]
        [Switch]$ShowSelection,
        [Parameter()]
        [Alias("Paging")]
        [Switch]$ShowPagination,
        [Parameter()]
        [ValidateSet("default", "checkbox", "none")]
        [string]$Padding = "default",
        [Parameter()]
        [ValidateSet("small", "medium")]
        [string]$Size = "medium",
        [Parameter()]
        [Hashtable]$TextOption = (New-UDTableTextOption),
        [Parameter()]
        [string[]]$ExportOption = @("XLSX", "PDF", "JSON", "CSV"),
        [Parameter()]
        [Endpoint]$OnExport,
        [Parameter()]
        [Switch]$DisablePageSizeAll,
        [Parameter()]
        [ValidateSet('ascending', 'descending')]
        [string]$DefaultSortDirection,
        [Parameter()]
        [Switch]$HideToggleAllRowsSelected,
        [Parameter()]
        [Switch]$DisableMultiSelect,
        [Parameter()]
        [Switch]$DisableSortRemove,
        [Parameter()]
        [Hashtable]$Icon
    )

    Begin {
        function getDefaultSortColumn {
            param(
                [Parameter()]    
                [object[]]$Columns
            )
            $DefaultSortColumn = $Columns.Where( { $_.DefaultSortColumn })
            $DefaultSortColumn.field
        }
    }
    Process {

        if ($OnExport)
        {
            $OnExport.Register($Id + 'Export', $PSCmdlet)
        }

        if ($null -eq $Data -and $null -eq  $LoadData) { 
            throw "No data entry point for Table $Id, you must used -Data or -LoadData parameters to populate the table." 
        }

        if (($null -eq $Columns) -and ($null -ne $Data)) {
            $item = $Data | Select-Object -First 1 | ConvertTo-FlatObject
    
            if ($item -is [Hashtable]) {
                $Columns = foreach ($member in $item.Keys) {
                    if ($ShowSearch) {
                        New-UDTableColumn -Property $member -IncludeInSearch
                    }
                    elseif ($ShowExport) {
                        New-UDTableColumn -Property $member -IncludeInExport
                    }
                    elseif ($ShowSearch -and $ShowExport) {
                        New-UDTableColumn -Property $member -IncludeInExport -IncludeInSearch
                    }
                    else {
                        New-UDTableColumn -Property $member
                    }
                }
                
            }
            else {
                $Columns = foreach ($member in $item.PSObject.Properties) {
                    if ($ShowSearch) {
                        New-UDTableColumn -Property $member.Name -IncludeInSearch
                    }
                    elseif ($ShowExport) {
                        New-UDTableColumn -Property $member.Name -IncludeInExport
                    }
                    elseif ($ShowSearch -and $ShowExport) {
                        New-UDTableColumn -Property $member.Name -IncludeInExport -IncludeInSearch
                    }
                    else {
                        New-UDTableColumn -Property $member.Name
                    }
                }
                
            }
        }

        if ($LoadData) {
            $LoadData.Register($Id, $PSCmdlet, @{ "TableColumns" = $Columns })
        }
            
        if ($OnRowSelection) {
            $OnRowSelection.Register($Id + 'OnRowSelection', $PSCmdlet)
        }        
        
        if ($Columns) {
            $RenderedColumns = $Columns.Where( { $null -ne $_.Render })
            if($Data.Count -ge 1){
                foreach ($Item in $Data) {
                    foreach ($Column in $RenderedColumns) {
                        $EventData = $Item
                        $RenderedData = & ([ScriptBlock]::Create($Column.Render.ToString()))
                        if (-not $RenderedData)
                        {
                            $RenderedData = ""
                        }

                        if ($Item -isnot [hashtable]) {
                            Add-Member -InputObject $Item -MemberType NoteProperty -Name "rendered$($Column.field)" -Value $RenderedData -Force
                        }
                        else {
                            $Item["rendered$($Column.field)"] = $RenderedData
                        }

                    }
                }
            }
        }

    }

    End {

        $defaultSortColumn = getDefaultSortColumn($Columns)
        if ($defaultSortColumn -and -not $DefaultSortDirection)
        {
            $DefaultSortDirection = 'ascending'
        }

        if ($Data) 
        { 
            $Data = [Array]($Data | ConvertTo-FlatObject) 
            if ($Data -isnot [Array]) {
                $Data = @($Data)
            }
        } 

        @{
            id                  = $Id 
            assetId             = $MUAssetId 
            isPlugin            = $true 
            type                = "mu-table"
    
            title               = $Title
            columns             = $Columns
            defaultSortColumn   = $defaultSortColumn
            data                = $Data
            showSort            = $ShowSort.IsPresent
            showFilter          = $ShowFilter.IsPresent
            showSearch          = $ShowSearch.IsPresent
            showExport          = $ShowExport.IsPresent 
            showSelection       = $ShowSelection.IsPresent 
            showPagination      = $ShowPagination.IsPresent
            isStickyHeader      = $StickyHeader.IsPresent
            isDense             = $Dense.IsPresent
            loadData            = $LoadData
            onRowSelection      = $OnRowSelection
            userPageSize        = $PageSize
            userPageSizeOptions = if ($PageSizeOptions.Count -gt 0) { $PageSizeOptions }else { @(5, 10, 20, 50) }
            padding             = $Padding.ToLower()
            size                = $Size
            textOption          = $TextOption
            exportOption        = $ExportOption | ForEach-Object { $_.ToUpper() }
            onExport            = $OnExport
            disablePageSizeAll  = $DisablePageSizeAll.IsPresent
            defaultSortDirection = $DefaultSortDirection.ToLower()
            hideToggleAllRowsSelected = $HideToggleAllRowsSelected.IsPresent
            disableMultiSelect = $DisableMultiSelect.IsPresent
            disableSortRemove = $DisableSortRemove.IsPresent
            icon = $Icon
        }
    }
}

function New-UDTableTextOption {
    <#
    .SYNOPSIS
    Creates a hashtable to set the text options of a table.
    
    .DESCRIPTION
    Creates a hashtable to set the text options of a table.
    
    .PARAMETER ExportAllCsv
    Overrides the Export All to CSV text.
    
    .PARAMETER ExportCurrentViewCsv
    Overrides the Export Current View as CSV text.
    
    .PARAMETER ExportAllXLSX
    Overrides the Export All to XLSX text.
    
    .PARAMETER ExportCurrentViewXLSX
    Overrides the Export Current View as XLSX text.
    
    .PARAMETER ExportAllPDF
    Overrides the Export All to PDF text.
    
    .PARAMETER ExportCurrentViewPDF
    Overrides the Export Current View as PDF text.
    
    .PARAMETER ExportAllJson
    Overrides the Export All to JSON text.
    
    .PARAMETER ExportCurrentViewJson
    Overrides the Export Current View as JSON text.
    
    .PARAMETER Search
    Overrides the Search text. You can use {0} to use as a place holder for the number of rows.
    
    .PARAMETER FilterSearch
    Overrides the column filter text. You can use {0} to use as a place holder for the number of rows.
    
    .EXAMPLE
    $Options = New-UDTableTextOption -Search "Filter all the rows"
    New-UDTable -Data $Data -TextOption $Ootions
    
    .NOTES
    General notes
    #>
    param(
        [Parameter()]
        [string]$ExportAllCsv = "Export all as CSV",
        [Parameter()]
        [string]$ExportCurrentViewCsv = "Export Current View as CSV",
        [Parameter()]
        [string]$ExportAllXLSX = "Export all as XLSX",
        [Parameter()]
        [string]$ExportCurrentViewXLSX = "Export Current View as XLSX",
        [Parameter()]
        [string]$ExportAllPDF = "Export all as PDF",
        [Parameter()]
        [string]$ExportCurrentViewPDF = "Export Current View as PDF",
        [Parameter()]
        [string]$ExportAllJson = "Export all as JSON",
        [Parameter()]
        [string]$ExportCurrentViewJson = "Export Current View as JSON",
        [Parameter()]
        [string]$ExportFileName = "File Name",
        [Parameter()]
        [string]$Search = "Search {0} records...",
        [Parameter()]
        [string]$FilterSearch = "Search {0} records..."
    )

    @{
        exportAllCsv = $ExportAllCsv
        exportCurrentViewCsv = $ExportCurrentViewCsv
        exportAllXlsx = $ExportAllXLSX
        exportCurrentViewXlsx = $ExportCurrentViewXLSX
        exportAllPdf = $ExportAllPDF
        exportCurrentViewPdf = $ExportCurrentViewPDF
        exportAllJson = $ExportAllJson
        exportCurrentViewJson = $ExportCurrentViewJson
        exportFileName = $ExportFileName
        search = $Search
        filterSearch = $FilterSearch
    }
}

function New-UDTableColumn {
    <#
    .SYNOPSIS
    Defines a table column.
    
    .DESCRIPTION
    Defines a table column. Use this cmdlet in conjunction with New-UDTable's -Column property. Table columns can be used to control many aspects of the columns within a table. 
    
    .PARAMETER Id
    The ID of the component. It defaults to a random GUID.
    
    .PARAMETER Property
    The property to select from the data. 
    
    .PARAMETER Title
    The title of the column to show at the top of the table. 
    
    .PARAMETER Render
    How to render this table. Use this parameter instead of property to render custom content within a column. The $Body variable will contain the current row being rendered. 
    
    .PARAMETER Sort
    Whether this column supports sorting.
    
    .PARAMETER Filter
    Whether this column supports filtering.
    
    .PARAMETER Search
    Whether this column supports searching.
    
    .EXAMPLE
    See New-UDTable for examples. 
    #>
    param(
        [Parameter()]
        [string]$Id = [Guid]::NewGuid().ToString(),
        [Parameter(Mandatory)]
        [string]$Property, 
        [Parameter()]
        [string]$Title,
        [Parameter()]
        [ScriptBlock]$Render,
        [Parameter()]
        [Alias("Sort")]
        [switch]$ShowSort,
        [Parameter()]
        [Alias("Filter")]
        [switch]$ShowFilter,
        [Parameter()]
        [ValidateSet("text", "select", "fuzzy", "slider", "range", "date", "number", 'autocomplete')]
        [string]$FilterType = "text",
        [Parameter()]
        [hashtable]$Style = @{},
        [Parameter()]
        [int]$Width,
        [Parameter()]
        [Alias("Search")]
        [switch]$IncludeInSearch,
        [Parameter()]
        [Alias("Export")]
        [switch]$IncludeInExport,
        [Parameter()]
        [switch]$DefaultSortColumn,
        [Parameter()]
        [ValidateSet('center', 'inherit', 'justify', 'left', 'right')]
        [string]$Align = 'inherit',
        [Parameter()]
        [Switch]$Truncate,
        [Parameter()]
        [ValidateSet('basic', 'datetime', 'alphanumeric')]
        [string]$SortType = 'alphanumeric'
    )

    if ($null -eq $Title -or $Title -eq '') {
        $Title = $Property
    }

    if ($Width -gt 0)
    {
        $style["maxWidth"] = $width
        $style["width"] = $width
    }

    if ($Truncate)
    {
        $style["whiteSpace"] = "nowrap"
        $style["overflow"] = "hidden"
        $style["textOverflow"] = "ellipsis"
    }

    @{
        id                  = $Id 
        field               = $Property.ToLower()
        title               = $Title 
        showSort            = $ShowSort.IsPresent 
        showFilter          = $ShowFilter.IsPresent
        filterType          = $FilterType.ToLower()
        includeInSearch     = $IncludeInSearch.IsPresent
        includeInExport     = $IncludeInExport.IsPresent
        isDefaultSortColumn = $DefaultSortColumn.IsPresent
        render              = $Render
        width               = $Width
        align               = $Align
        style               = $Style
        sortType            = $SortType

    }
}
function Out-UDTableData {
    <#
    .SYNOPSIS
    Formats data to be output from New-UDTable's -LoadData script block. 
    
    .DESCRIPTION
    Formats data to be output from New-UDTable's -LoadData script block. 
    
    .PARAMETER Data
    The data to return from LoadData. 
    
    .PARAMETER Page
    The current page we are on within the table. 
    
    .PARAMETER TotalCount
    The total count of items within the data set. 
    
    .PARAMETER Properties
    The properties that are currently passed from the table. You can return the array from the $EventData.Properties array. 
    
    .EXAMPLE
    See New-UDTable for examples. 
    #>
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory)]
        [object]$Data,
        [Parameter(Mandatory)]
        [int]$Page,
        [Parameter(Mandatory)]
        [int]$TotalCount,
        [Parameter(Mandatory)]
        [Alias("Property")]
        [string[]]$Properties
    )

    Begin {
        $DataPage = @{
            data       = @() 
            page       = $Page 
            totalCount = $TotalCount
        }
    }

    Process {
        $item = @{}
        foreach ($property in $Properties) {
            $RenderedColumn = $TableColumns.Where( { $_.field -eq $property -and $_.Render })
            if ($RenderedColumn) {
                $EventData = $Data
                $item["rendered" + $property] = & ([ScriptBlock]::Create($RenderedColumn.Render.ToString()))
            }

            $item[$property] = $Data[$property]
        }
        $DataPage.data += $item
    }

    End {
        if ($DataPage.data)
        {
            $DataPage.data = [Array]($DataPage.data | ConvertTo-FlatObject)
            $DataPage
        }
    }
}