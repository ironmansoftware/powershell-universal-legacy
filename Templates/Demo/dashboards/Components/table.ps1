New-UDPage -Name 'New-UDTable' -Content {
    New-UDTypography -Text 'Simple Table' -Variant 'h4'

    $Data = @(
        @{Dessert = 'Frozen yoghurt'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Ice cream sandwich'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Eclair'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Cupcake'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Gingerbread'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
    ) 

    New-UDTable -Data $Data

    New-UDTypography -Text 'Table with Custom Columns' -Variant 'h4'

    $Data = @(
        @{Dessert = 'Frozen yoghurt'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Ice cream sandwich'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Eclair'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Cupcake'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Gingerbread'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
    ) 

    $Columns = @(
        New-UDTableColumn -Property Dessert -Title "A Dessert"
        New-UDTableColumn -Property Calories -Title Calories 
        New-UDTableColumn -Property Fat -Title Fat 
        New-UDTableColumn -Property Carbs -Title Carbs 
        New-UDTableColumn -Property Protein -Title Protein 
    )

    New-UDTable -Id 'customColumnsTable' -Data $Data -Columns $Columns

    New-UDTypography -Text 'Table with Custom Column Rendering' -Variant 'h4'

    $Data = @(
        @{Dessert = 'Frozen yoghurt'; Calories = 1; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Ice cream sandwich'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Eclair'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Cupcake'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Gingerbread'; Calories = 200; Fat = 6.0; Carbs = 24; Protein = 4.0}
    ) 

    $Columns = @(
        New-UDTableColumn -Property Dessert -Title Dessert -Render { 
            New-UDButton -Id "btn$($EventData.Dessert)" -Text "Click for Dessert!" -OnClick { Show-UDToast -Message $EventData.Dessert } 
        }
        New-UDTableColumn -Property Calories -Title Calories 
        New-UDTableColumn -Property Fat -Title Fat 
        New-UDTableColumn -Property Carbs -Title Carbs 
        New-UDTableColumn -Property Protein -Title Protein 
    )

    New-UDTable -Data $Data -Columns $Columns -Sort -Export

    New-UDTypography -Text 'Table Column Width' -Variant 'h4'

    $Data = @(
        @{Dessert = 'Frozen yoghurt'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Ice cream sandwich'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Eclair'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Cupcake'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Gingerbread'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
    ) 

    $Columns = @(
        New-UDTableColumn -Property Dessert -Title Dessert -Render { 
            New-UDButton -Id "btn$($EventData.Dessert)" -Text "Click for Dessert!" -OnClick { Show-UDToast -Message $EventData.Dessert } 
        }
        New-UDTableColumn -Property Calories -Title Calories -Width 5 -Truncate
        New-UDTableColumn -Property Fat -Title Fat 
        New-UDTableColumn -Property Carbs -Title Carbs 
        New-UDTableColumn -Property Protein -Title Protein 
    )

    New-UDTable -Data $Data -Columns $Columns -Sort

    New-UDTypography -Text 'Filters' -Variant 'h4'

    $Data = @(
        @{Dessert = 'Frozen yoghurt'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Ice cream sandwich'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Eclair'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Cupcake'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Gingerbread'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
    ) 

    $Columns = @(
        New-UDTableColumn -Property Dessert -Title "A Dessert" -Filter -FilterType AutoComplete
        New-UDTableColumn -Property Calories -Title Calories -Filter -FilterType Range
        New-UDTableColumn -Property Fat -Title Fat -Filter -FilterType Range
        New-UDTableColumn -Property Carbs -Title Carbs -Filter -FilterType Range
        New-UDTableColumn -Property Protein -Title Protein -Filter -FilterType Range
    )

    New-UDTable -Data $Data -Columns $Columns -ShowFilter

    New-UDTypography -Text 'Paging' -Variant 'h4'

    $Data = @(
        @{Dessert = 'Frozen yoghurt'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Ice cream sandwich'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Eclair'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Cupcake'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Gingerbread'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
    ) 

    New-UDTable -Data $Data -Paging -PageSize 2

    New-UDTypography -Text 'Sorting' -Variant 'h4'

    $Data = @(
        @{Dessert = 'Frozen yoghurt'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Ice cream sandwich'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Eclair'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Cupcake'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
        @{Dessert = 'Gingerbread'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0}
    ) 

    New-UDTable -Data $Data -ShowSort

    New-UDTypography -Text 'Selection' -Variant 'h4'

    $Data = try { get-service -ea Stop | select Name,@{n = "Status";e={ $_.Status.ToString()}},@{n = "StartupType";e={ $_.StartupType.ToString()}},@{n = "StartType";e={ $_.StartType.ToString()}} } catch {}
    $Columns = @(
        New-UDTableColumn -Property Name -Title "Service Name" -ShowSort -IncludeInExport -IncludeInSearch -ShowFilter -FilterType text
        New-UDTableColumn -Property Status -Title Status -ShowSort -DefaultSortColumn -IncludeInExport -IncludeInSearch -ShowFilter -FilterType select 
        New-UDTableColumn -Property StartupType -Title StartupType -IncludeInExport -ShowFilter -FilterType select
        New-UDTableColumn -Property StartType -Title StartType -IncludeInExport -ShowFilter -FilterType select 
    )
    New-UDTable -Id 'service_table' -Data $Data -Columns $Columns -Title 'Services' -ShowSearch -ShowPagination -ShowSelection -Dense -OnRowSelection {
        $Item = $EventData
        Show-UDToast -Message "$($Item | out-string)"
    }
    New-UDButton -Text "GET Rows" -OnClick {
        $value = Get-UDElement -Id "service_table"
        Show-UDToast -Message "$( $value.selectedRows | Out-String )"
    }

    New-UDTypography -Text 'Exporting' -Variant 'h4'

    $Data = try { get-service -ea Stop | select Name,@{n = "Status";e={ $_.Status.ToString()}},@{n = "StartupType";e={ $_.StartupType.ToString()}},@{n = "StartType";e={ $_.StartType.ToString()}} } catch {}
    $Columns = @(
        New-UDTableColumn -Property Name -Title "Service Name" -IncludeInExport
        New-UDTableColumn -Property Status -Title Status 
        New-UDTableColumn -Property StartupType
        New-UDTableColumn -Property StartType -IncludeInExport
    )
    New-UDTable -Id 'service_table' -Data $Data -Columns $Columns -Title 'Services' -ShowSearch -ShowPagination -Dense -Export
}