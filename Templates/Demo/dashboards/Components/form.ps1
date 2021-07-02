New-UDPage -Name 'New-UDForm' -Content {
    New-UDTypography -Text 'Simple Form' -Variant 'h4'

    New-UDForm -Content {
        New-UDTextbox -Id 'txtTextfield'
        New-UDCheckbox -Id 'chkCheckbox'
    } -OnSubmit {
        Show-UDToast -Message $EventData.txtTextfield
        Show-UDToast -Message $EventData.chkCheckbox
    }

    New-UDTypography -Text 'Formatting a Form' -Variant 'h4'

    New-UDForm -Content {

        New-UDRow -Columns {
            New-UDColumn -SmallSize 6 -LargeSize 6 -Content {
                New-UDTextbox -Id 'txtFirstName' -Label 'First Name' 
            }
            New-UDColumn -SmallSize 6 -LargeSize 6 -Content {
                New-UDTextbox -Id 'txtLastName' -Label 'Last Name'
            }
        }
    
        New-UDTextbox -Id 'txtAddress' -Label 'Address'
    
        New-UDRow -Columns {
            New-UDColumn -SmallSize 6 -LargeSize 6  -Content {
                New-UDTextbox -Id 'txtState' -Label 'State'
            }
            New-UDColumn -SmallSize 6 -LargeSize 6  -Content {
                New-UDTextbox -Id 'txtZipCode' -Label 'ZIP Code'
            }
        }
    
    } -OnSubmit {
        Show-UDToast -Message $EventData.txtFirstName
        Show-UDToast -Message $EventData.txtLastName
    }

    New-UDTypography -Text 'Returning components' -Variant 'h4'

    New-UDForm -Content {
        New-UDTextbox -Id 'txtTextfield'
    } -OnSubmit {
        New-UDTypography -Text $EventData.txtTextfield
    }

    New-UDTypography -Text 'Validating a form' -Variant 'h4'

    New-UDForm -Content {
        New-UDTextbox -Id 'txtValidateForm'
    } -OnValidate {
        $FormContent = $EventData
    
        if ($FormContent.txtValidateForm -eq $null -or $FormContent.txtValidateForm -eq '') {
            New-UDFormValidationResult -ValidationError "txtValidateForm is required"
        } else {
            New-UDFormValidationResult -Valid
        }
    } -OnSubmit {
        Show-UDToast -Message $Body
    }

    New-UDTypography -Text 'Canceling a Form' -Variant 'h4'

    New-UDButton -Text 'On Form' -OnClick {
        Show-UDModal -Content {
            New-UDForm -Content {
                New-UDTextbox -Label 'Hello'
            } -OnSubmit {
                Show-UDToast -Message 'Submitted!'
                Hide-UDModal
            } -OnCancel {
                Hide-UDModal
            }
        }
    }

    New-UDTypography -Text 'Displaying output without Replacing the form' -Variant 'h4'

    New-UDForm -Content {

    } -OnSubmit {
       Set-UDElement -Id 'results' -Content {
          New-UDCard -Content { "Hello " + (Get-Date) }
       }
    }
    
    New-UDElement -Id 'results' -Tag 'div'
}