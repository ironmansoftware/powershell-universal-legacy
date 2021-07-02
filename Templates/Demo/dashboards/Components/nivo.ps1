New-UDPage -Name 'New-UDNivoChart' -Content {
    New-UDTypography -Text 'Creating a chart' -Variant 'h4'

    $Data = 1..10 | ForEach-Object { 
        $item = Get-Random -Max 1000 
        [PSCustomObject]@{
            Name = "Test$item"
            Value = $item
        }
    }
    New-UDNivoChart -Bar -Keys "value" -IndexBy 'name' -Data $Data -Height 500 -Width 1000

    New-UDTypography -Text 'Patterns' -Variant 'h4'

    $Data = @(
        @{
            country = 'USA'
            burgers = (Get-Random -Minimum 10 -Maximum 100)
            fries = (Get-Random -Minimum 10 -Maximum 100)
            sandwich = (Get-Random -Minimum 10 -Maximum 100)
        }
        @{
            country = 'Germany'
            burgers = (Get-Random -Minimum 10 -Maximum 100)
            fries = (Get-Random -Minimum 10 -Maximum 100)
            sandwich = (Get-Random -Minimum 10 -Maximum 100)
        }
        @{
            country = 'Japan'
            burgers = (Get-Random -Minimum 10 -Maximum 100)
            fries = (Get-Random -Minimum 10 -Maximum 100)
            sandwich = (Get-Random -Minimum 10 -Maximum 100)
        }
    )

    $Pattern = New-UDNivoPattern -Dots -Id 'dots' -Background "inherit" -Color "#38bcb2" -Size 4 -Padding 1 -Stagger
    $Fill = New-UDNivoFill -ElementId "fries" -PatternId 'dots'

    New-UDNivoChart -Definitions $Pattern -Fill $Fill -Bar -Data $Data -Height 400 -Width 900 -Keys @('burgers', 'fries', 'sandwich')  -IndexBy 'country'

    New-UDTypography -Text 'Auto refreshing charts' -Variant 'h4'

    New-UDDynamic -Content {
        $Data = 1..10 | ForEach-Object { 
            $item = Get-Random -Max 1000 
            [PSCustomObject]@{
                Name = "Test$item"
                Value = $item
            }
        }
        New-UDNivoChart -Id 'autoRefreshingNivoBar' -Bar -Keys "value" -IndexBy 'name' -Data $Data -Height 500 -Width 1000
    } -AutoRefresh -AutoRefreshInterval 3

    New-UDTypography -Text 'OnClick Event Handler' -Variant 'h4'

    $Data = @(
        @{
            country = 'USA'
            burgers = (Get-Random -Minimum 10 -Maximum 100)
            fries = (Get-Random -Minimum 10 -Maximum 100)
            sandwich = (Get-Random -Minimum 10 -Maximum 100)
        }
        @{
            country = 'Germany'
            burgers = (Get-Random -Minimum 10 -Maximum 100)
            fries = (Get-Random -Minimum 10 -Maximum 100)
            sandwich = (Get-Random -Minimum 10 -Maximum 100)
        }
        @{
            country = 'Japan'
            burgers = (Get-Random -Minimum 10 -Maximum 100)
            fries = (Get-Random -Minimum 10 -Maximum 100)
            sandwich = (Get-Random -Minimum 10 -Maximum 100)
        }
    )
    New-UDNivoChart -Bar -Data $Data -Height 400 -Width 900 -Keys @('burgers', 'fries', 'sandwich')  -IndexBy 'country' -OnClick {
        Show-UDToast -Message $EventData -Position topLeft
    }

    New-UDTypography -Text 'Bubble Chart' -Variant 'h4'

    $TreeData = @{
        Name     = "root"
        children = @(
            @{
                Name  = "first"
                children = @(
                    @{
                        Name = "first-first"
                        Count = 7
                    }
                    @{
                        Name = "first-second"
                        Count = 8
                    }
                )
            },
            @{
                Name  = "second"
                Count = 21
            }
        )
    }
    
    New-UDNivoChart -Bubble -Data $TreeData -Value "count" -Identity "name" -Height 500 -Width 800

    New-UDTypography -Text 'Calendar Chart' -Variant 'h4'

    $Data = @()
    for($i = 365; $i -gt 0; $i--) {
        $Data += @{
            day = (Get-Date).AddDays($i * -1).ToString("yyyy-MM-dd")
            value = Get-Random
        }
    }

    $From = (Get-Date).AddDays(-365)
    $To = Get-Date

    New-UDNivoChart -Calendar -Data $Data -From $From -To $To -Height 500 -Width 1000 -MarginTop 50 -MarginRight 130 -MarginBottom 50 -MarginLeft 60

    New-UDTypography -Text 'Heatmap Chart' -Variant 'h4'

    $Data = @(
        @{
            state = "idaho"
            cats = 72307
            dogs = 23429
            moose = 23423
            bears = 784
        }
        @{
            state = "wisconsin"
            cats = 2343342
            dogs = 3453623
            moose = 1
            bears = 23423
        }
        @{
            state = "montana"
            cats = 9234
            dogs = 3973457
            moose = 23472
            bears = 347303
        }
        @{
            state = "colorado"
            cats = 345973789
            dogs = 0237234
            moose = 2302
            bears = 2349772
        }
    )
    New-UDNivoChart -Heatmap -Data $Data -IndexBy 'state' -keys @('cats', 'dogs', 'moose', 'bears')  -Height 500 -Width 1000 -MarginTop 50 -MarginRight 130 -MarginBottom 50 -MarginLeft 60

    New-UDTypography -Text 'Line Chart' -Variant 'h4'

    [array]$Data = [PSCustomObject]@{
        id = "DataSet"
        data = (1..20 | ForEach-Object {
            $item = Get-Random -Max 500 
            [PSCustomObject]@{
                x = "Test$item"
                y = $item
            }
        })
    }
    New-UDNivoChart -Line -Data $Data -Height 500 -Width 1000 -LineWidth 1

    New-UDTypography -Text 'Stream Chart' -Variant 'h4'

    $Data = 1..10 | ForEach-Object { 
        @{
            "Adam" = Get-Random 
            "Alon" = Get-Random 
            "Lee" = Get-Random 
            "Frank" = Get-Random 
            "Bill" = Get-Random 
        }
    }
    
    New-UDNivoChart -Stream -Data $Data -Height 500 -Width 1000 -Keys @("adam", "alon", "lee", "frank", "bill")

    New-UDTypography -Text 'Treemap Chart' -Variant 'h4'

    $TreeData = @{
        Name     = "root"
        children = @(
            @{
                Name  = "first"
                children = @(
                    @{
                        Name = "first-first"
                        Count = 7
                    }
                    @{
                        Name = "first-second"
                        Count = 8
                    }
                )
            },
            @{
                Name  = "second"
                Count = 21
            }
        )
    }
    
    New-UDNivoChart -Treemap -Data $TreeData -Value "count" -Identity "name" -Height 500 -Width 800
}