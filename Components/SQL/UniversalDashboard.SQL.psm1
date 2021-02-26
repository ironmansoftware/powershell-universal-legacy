function New-UDSQLTable {
    <#
    .SYNOPSIS
    Creates a table based on a SQL query.
    
    .DESCRIPTION
    Creates a table based on a SQL query. Requires DBATools.
    
    .PARAMETER Title
    The title of the table.
    
    .PARAMETER Query
    The query used to look up table data.
    
    .PARAMETER CountQuery
    The query used to count table data.
    
    .PARAMETER SqlInstance
    The SQL instance to connect to. 
    
    .PARAMETER Database
    The database to connect to. 
    
    .PARAMETER Columns
    The columns to display. 
    
    .PARAMETER Credential
    The credential used to connect to the SQL instance. 
    
    .EXAMPLE
    New-UDSQLTable -Title 'Podcasts' -Columns @("name", "host") -Query "SELECT * FROM shows" -CountQuery "SELECT COUNT(*) as Count from shows" -SQLInstance "localhost" -Database "podcasts"

    Creates a table based on the shows table in the Podcasts database. 
    #>
    param(
        [Parameter()]
        [string]$Title,
        [Parameter(Mandatory)]
        [string]$Query,
        [Parameter(Mandatory)]
        [string]$CountQuery,
        [Parameter(Mandatory)]
        [string]$SqlInstance,
        [Parameter(Mandatory)]
        [string]$Database,
        [Parameter(Mandatory)]
        [string[]]$Columns,
        [Parameter()]
        [PSCredential]$Credential
    )

    $TableColumns = $Columns | ForEach-Object {
        New-UDTableColumn -Title $_ -Property $_ -Filter
    }

    New-UDTable -Title $Title -LoadData {
        $TableData = ConvertFrom-Json $Body
    
        $OrderBy = $TableData.orderBy.field
        if ($OrderBy -eq $null)
        {
            $OrderBy = $Columns | Select-Object -First 1
        }
    
        $OrderDirection = $TableData.OrderDirection
        if ($OrderDirection -eq $null)
        {
            $OrderDirection = 'asc'
        }
    
        $Where = " "

        if ($TableData.Filters) 
        {
            $Where = "WHERE "
            foreach($filter in $TableData.Filters)
            {
                Show-UDToast -Message ($Filter | ConvertTo-Json)
                $Where += $filter.id + " LIKE '%" + $filter.value + "%' AND "
            }
            $Where += " 1 = 1"
        }

        $PageSize = $TableData.PageSize 
        # Calculate the number of rows to skip
        $Offset = $TableData.Page * $PageSize

        $Parameters = @{
            SqlInstance = $SqlInstance 
            Database = $Database 
            Query = "$CountQuery $Where"
        }

        if ($PSCredential)
        {
            $Parameters["SqlCredential"] = $PSCredential
        }

        $Count = Invoke-DbaQuery @Parameters

        $Parameters = @{
            SqlInstance = $SqlInstance 
            Database = $Database 
            Query = "$Query $Where ORDER BY $orderBy $orderdirection OFFSET $Offset ROWS FETCH NEXT $PageSize ROWS ONLY" 
        }

        if ($PSCredential)
        {
            $Parameters["SqlCredential"] = $PSCredential
        }
    
        $Data = Invoke-DbaQuery @Parameters
        $Data | Out-UDTableData -Page $TableData.page -TotalCount $Count.Count -Properties $TableData.properties
    } -Columns $TableColumns -Sort -Filter -Paging
}