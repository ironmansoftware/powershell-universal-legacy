function New-UDHVVMWizard 
{
    <#
    .SYNOPSIS
    Creates a wizard for creating new virtual machines.
    
    .DESCRIPTION
    Creates a wizard for creating new virtual machines.
    
    .PARAMETER ComputerName
    The Hyper-V host to connect to.
    
    .PARAMETER Credential
    The credential needed to connect to the Hyper-V host.
    
    .PARAMETER IsoPath
    The local path on the Hyper-V host that contains ISOs for installation media.
    
    .EXAMPLE
    New-UDHVVMWizard -IsoPath 'C:\isos'

    Creates a wizard using the local path C:\isos for installation media and use the local machine and credentials. 
    #>
    param(
        [Parameter()]
        [string]$ComputerName,
        [Parameter()]
        [PSCredential]$Credential,
        [Parameter()]
        [string]$IsoPath
    )

    $ConnectionInfo = @{}

    if ($ComputerName)
    {
        $ConnectionInfo["ComputerName"] = $ComputerName 
    }

    if ($Credential)
    {
        $ConnectionInfo["Credential"] = $Credential 
    }

    New-UDStepper -Steps {
        New-UDStep -OnLoad {
            New-UDRow {
                New-UDTypography -Text "Choose a name and location for this virtual machine."
            }

            New-UDRow {
                New-UDTextbox -Id 'name' -Value $EventData.Context.name -Label 'Name'
            }

            New-UDRow {
                New-UDTypography "Stored at default path: $((Get-VMHost @ConnectionInfo).VirtualMachinePath)"
            }

        } -Label "Name and Location"
        New-UDStep -OnLoad {
            New-UDTypography -Text "Choose the generation of this virtual machine."

            New-UDRadioGroup -Label "Generation" -Content {
                New-UDRadio -Label 'Generation 1' -Value '1'
                New-UDRadio -Label 'Generation 2' -Value '2'
            } -Value $EventData.Context.generation -Id 'generation'
        } -Label "Generation"
        New-UDStep -OnLoad {
            New-UDRow {
                New-UDTypography -Text "Specify the amount of memory to allocate to this virtual machine."
            }
            
            New-UDRow {
                New-UDTextbox -Id 'memory' -Value $EventData.Context.memory -Label 'Memory (MB)'
            }

            $Dynamic = $false 
            if ($EventData.Context.dynamicMemory)
            {
                [bool]$Dynamic = $EventData.Context.dynamicMemory
            }

            New-UDRow {
                New-UDCheckBox -Label 'Use Dynamic Memory' -Id 'dynamicMemory' -Checked $Dynamic
            }
                        
        } -Label "Memory"
        New-UDStep -OnLoad {
            New-UDRow {
                New-UDTypography -Text "Each new virtual machine includes a network adapter. You can configure the network adapter to use a virtual switch, or it can remain disconnected"
            }
            
            New-UDSelect -Option {
                Get-VMSwitch @ConnectionInfo | ForEach-Object {
                    New-UDSelectOption -Value $_.Name -Name $_.Name
                }
            } -Id 'network' -DefaultValue $EventData.Context.network
        } -Label "Networking"
        New-UDStep -OnLoad {
            New-UDRow {
                New-UDTypography -Text "Configure the virtual hard drisk size."
            }
            
            New-UDTextbox -Id 'hardDiskSize' -Value $EventData.Context.hardDiskSize -Label 'Size (GB)'
        } -Label "Virtual Hard Disk"
        New-UDStep -OnLoad {
            New-UDRow {
                New-UDTypography -Text "Select the operating system to install."
            }
            
            New-UDSelect -Option {
                Get-ChildItem -Path (Join-Path $IsoPath "*.iso") | ForEach-Object {
                    New-UDSelectOption -Value $_.FullName -Name $_.Name
                }
            } -Id 'iso' -DefaultValue $EventData.Context.iso
            
        } -Label "Installation"
    } -OnFinish {

        try
        {
            $memoryBytes = ([int]$EventData.context.memory) * 1MB
            $vhdBytes = ([int]$EventData.context.hardDiskSize) * 1GB
            $VHDPath = Join-Path (Get-VMHost @ConnectionInfo).VirtualHardDiskPath "$($EventData.Context.name).vhdx"
            $VM = New-VM -Name $EventData.Context.name -Generation $EventData.Context.generation -SwitchName $EventData.Context.network -MemoryStartupBytes $memoryBytes -NewVHDSizeBytes $vhdBytes -NewVHDPath $VHDPath @ConnectionInfo
            [bool]$DynamicMemory = $EventData.Context.dynamicMemory
            Set-VM -VM $VM -DynamicMemory:$DynamicMemory @ConnectionInfo
    
            Set-VMDvdDrive -VMName $VM.Name -Path $EventData.Context.iso @ConnectionInfo

            Show-UDToast -Message "Successfully created VM $($EventData.Context.name)" -Duration 5000
        }
        catch 
        {
            Show-UDToast -Message "Failed to create VM. $_" -Duration 5000
        }
    } -Orientation vertical
}
