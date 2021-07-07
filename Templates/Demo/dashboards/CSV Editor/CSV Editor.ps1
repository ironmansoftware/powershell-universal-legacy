New-UDDashboard -Title "Hello, World!" -Content {
    New-UDUpload -OnUpload {
        $Csv = [IO.Path]::GetTempFileName()
        $Data = $Body | ConvertFrom-Json 
        $bytes = [System.Convert]::FromBase64String($Data.Data)
        [System.IO.File]::WriteAllBytes($Csv, $bytes)
        $Session:CsvPath = $Csv

        Sync-UDElement -Id 'table'
    } -Text 'Upload CSV'

    New-UDButton -Text "Add Row" -OnClick {
        $Session:ShowAdd = $true 
        Sync-UDElement -Id 'addEditor'
    }

    New-UDDynamic -Id 'table' -Content {
        if ($Session:CsvPath)
        {
            $Csv = Import-Csv -Path $Session:CsvPath
            New-UDTable -Data $Csv -ShowSelection -OnRowSelection {
                if ($EventData.Selected)
                {
                    $Session:SelectedRow = $EventData
                    Sync-UDElement -Id 'editor'
                }

            } -DisableMultiSelect
        }
    }

    New-UDDynamic -Id 'editor' -Content {
        if ($Session:SelectedRow)
        {
            New-UDCard -Title "Edit row $($Session:SelectedRow.Id)" -Content {
                New-UDForm -Content {
                    $Csv = Import-Csv -Path $Session:CsvPath
                    $RowData = $Csv[$Session:SelectedRow.Id]
                    $RowData | Get-Member -MemberType Properties | ForEach-Object {
                        New-UDTextbox -Id $_.Name -Label $_.Name -Value $RowData.$($_.Name)
                    }
                } -OnSubmit {
                    $Csv = Import-Csv -Path $Session:CsvPath
                    $Csv[$Session:SelectedRow.Id] = $EventData 
                    $Csv | Export-Csv -Path $Session:CsvPath
                    $Session:SelectedRow = $null

                    Sync-UDElement -Id 'editor'
                    Sync-UDElement -Id 'table'
                } -OnCancel {
                    $Session:SelectedRow = $null
                    Sync-UDElement -Id 'editor'
                }
            }
        }
    }

    New-UDDynamic -Id 'addEditor' -Content {
        if ($Session:ShowAdd)
        {
            New-UDCard -Title "Add Row" -Content {
                New-UDForm -Content {
                    $Csv = Import-Csv -Path $Session:CsvPath
                    $RowData = $Csv[0]
                    $RowData | Get-Member -MemberType Properties | ForEach-Object {
                        New-UDTextbox -Id $_.Name -Label $_.Name 
                    }
                } -OnSubmit {
                    $Csv = Import-Csv -Path $Session:CsvPath
                    $Csv += $EventData 
                    $Csv | Export-Csv -Path $Session:CsvPath
                    $Session:ShowAdd = $false

                    Sync-UDElement -Id 'addEditor'
                    Sync-UDElement -Id 'table'
                } -OnCancel {
                    $Session:ShowAdd = $false
                    Sync-UDElement -Id 'addEditor'
                }
            }
        }
    }
}