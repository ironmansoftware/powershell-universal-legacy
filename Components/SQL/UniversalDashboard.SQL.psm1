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

function New-UDSQLQueryTool {
    <#
    .SYNOPSIS
    Creates a tool used to execute SQL queries.
    
    
    .DESCRIPTION
    Creates a tool used to execute SQL queries. This function requires dbatools, UDStyle and UDCodeEditor. 
    
    .PARAMETER SqlInstance
    The name of the SQL instance to connect to. 
    
    .PARAMETER Database
    The database to connect to. 
    
    .PARAMETER Credential
    The credential to use to connect to the database. 
    
    .PARAMETER IntegratedAuthentication
    Whether to use integrated authentication. 
    
    .EXAMPLE
    New-UDSQLQueryTool

    Creates a tool that will require the user to enter the database connection information. 

    .EXAMPLE
    New-UDSQLQueryTool -SqlInstance localhost -Database podcasts -IntegratedAuthentication

    Creates a tool that will connect to the local instance and podcast database using integrated authentication.  
    #>
    param(
        [Parameter()]
        [string]$SqlInstance,
        [Parameter()]
        [string]$Database,
        [Parameter()]
        [PSCredential]$Credential,
        [Parameter()]
        [Switch]$IntegratedAuthentication
    )

    New-UDStyle -Style "float: left" -Content {
        if ($SqlInstance -and ($Credential -or $IntegratedAuthentication))
        {
            $Session:SqlInstance = $Session:SqlInstance
            if ($null -ne $Credential)
            {
                $Session:Credential = $Credential
            }
        }
        else
        {
            New-UDButton -Text 'Connect' -Id 'connect' -OnClick {
                Show-UDModal -Content {
                    New-UDForm -Content {
                        if (-not $SqlInstance)
                        {
                            New-UDTextbox -Id 'sqlInstance' -Label 'SQL Instance'
                        }

                        if (-not ($IntegratedAuthentication -or $Credential))
                        {
                            New-UDTextbox -Id 'username' -Label 'User Name'
                            New-UDTextbox -Id 'password' -Label 'Password' -Type password

                            New-UDCheckbox -Id 'integratedAuth' -Label 'Integrated Authentication' -OnChange {
                                Set-UDElement -Id 'username' -Properties @{ disabled = -not $EventData } 
                                Set-UDElement -Id 'password' -Properties @{ disabled = -not $EventData } 
                            }
                        }
                    } -OnSubmit {
                        $Session:SqlInstance = $EventData.SqlInstance 

                        if (-not $EventData.integratedAuth)
                        {
                            $SecurePassword = ConvertTo-SecureString -String $EventData.Password -AsPlainText 
                            $Session:Credential = [PSCredential]::new($EventData.username, $SecurePassword)
                        }

                        Set-UDElement -Id 'databases' -Content {
                            New-UDSelect -Id 'databaseSelect' -Option {
                                Get-DbaDatabase -SqlInstance $Session:SqlInstance | ForEach-Object {
                                    New-UDSelectOption -Name $_.Name -Value $_.Name
                                }
                            } -OnChange {
                                $Session:Database = $EventData
                            }
                        }

                        Hide-UDModal
                        Remove-Element -Id 'connect'
                    }
                }
            }
        } 
    }

    New-UDStyle -Style 'float: left' -Content {
        New-UDButton -Text 'Execute' -OnClick {
            $Query = (Get-UDElement -Id 'editor').code
            $Results = Invoke-DbaQuery -SqlInstance $Session:SqlInstance -SqlCredential $Session:Credential -Database $Session:Database -Query $Query
            Set-UDElement -Id 'results' -Content {
                New-UDTable -Data $Results -Paging
            }
        }  -Icon (New-UDIcon -Icon play) 
    }

    New-UDStyle -Style 'float: left' -Content {
        if (-not $Database) {
            New-UDElement -Id 'databases' -Tag 'div'
        } else {
            $Session:Database = $Database
        }
    }

    New-UDStyle -Style 'display: inline-block; width: 100%' -Content {
        New-UDCodeEditor -Language sql -Height 300px -Id 'editor'
    }

    New-UDElement -Tag div -Id 'results'
}