New-UDPage -Name 'New-UDElement' -Content {
    New-UDTypography -Text 'Create an element' -Variant 'h4'

    New-UDElement -Tag 'div' -Content { 'Hello' }

    New-UDTypography -Text 'Nested elements' -Variant 'h4'

    New-UDElement -Tag 'ul' -Content {
        New-UDElement -Tag 'li' -Content { 'First' }
        New-UDElement -Tag 'li' -Content { 'Second' }
        New-UDElement -Tag 'li' -Content { 'Third' }
    }

    New-UDTypography -Text 'Setting attributes' -Variant 'h4'

    New-UDElement -Tag 'div' -Content { 'Hello' } -Attributes @{
        style = @{
            color = 'red'
        }
    }

    New-UDTypography -Text 'Auto Refreshing Elements' -Variant 'h4'

    New-UDElement -Tag 'div' -Endpoint {
        Get-Date
    } -AutoRefresh -RefreshInterval 1

    New-UDTypography -Text 'Setting Element Content Dynamically' -Variant 'h4'

    New-UDElement -Tag 'div' -Id 'myElement' -Content { }

    New-UDButton -Text 'Click Me' -OnClick {
        Set-UDElement -Id 'myElement' -Content { Get-Date }
    }

    New-UDTypography -Text 'Setting Element Properties Dynamically' -Variant 'h4'

    New-UDElement -Tag 'div' -Id 'myElement2' -Content { }

    New-UDButton -Text 'Click Me' -OnClick {
        Set-UDElement -Id 'myElement2' -Content { Get-Date } -Properties @{ Attributes = @{ style = @{ color = "red" } } }
    }

    New-UDTypography -Text 'Adding Child Elements' -Variant 'h4'

    New-UDElement -Tag 'ul' -Content {

    } -Id 'myList'
    
    New-UDButton -Text 'Click Me' -OnClick {
        Add-UDElement -ParentId 'myList' -Content {
            New-UDElement -Tag 'li' -Content { Get-Date }
        }
    }

    New-UDTypography -Text 'Clearing Child Elements' -Variant 'h4'

    New-UDElement -Tag 'ul' -Content {
        New-UDElement -Tag 'li' -Content { 'First' }
        New-UDElement -Tag 'li' -Content { 'Second' }
        New-UDElement -Tag 'li' -Content { 'Third' }
    }  -Id 'myList2'
    
    New-UDButton -Text 'Click Me' -OnClick {
        Clear-UDElement -Id 'myList2'
    }

    New-UDTypography -Text 'Forcing an Element to Reload' -Variant 'h4'

    New-UDElement -Tag 'div' -Endpoint {
        Get-Date
    } -Id 'myDiv'
    
    New-UDButton -Text 'Click Me' -OnClick {
        Sync-UDElement -Id 'myDiv'
    }

    New-UDTypography -Text 'Removing an Element' -Variant 'h4'

    New-UDElement -Tag 'div' -Endpoint {
        Get-Date
    } -Id 'myDiv2'
    
    New-UDButton -Text 'Click Me' -OnClick {
        Remove-UDElement -Id 'myDiv2'
    }
}