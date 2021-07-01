New-PSUEndpoint -Url "/service" -Description "Returns services on this machine. " -Endpoint {
Get-Service | ForEach-Object {
    @{
        Name = $_.Name
        Status = $_.Status.ToString()
    }
}
} 
New-PSUEndpoint -Url "/process" -Description "Returns processes running on this machine." -Endpoint {
Get-Process | ForEach-Object {
    @{ 
        Name = $_.Name 
        Id = $_.Id
    }
}
} 
New-PSUEndpoint -Url "/info" -Description "Returns computer information about this machine." -Endpoint {
Get-ComputerInfo
} 
New-PSUEndpoint -Url "/disk" -Description "Returns disk information for this machine." -Endpoint {
Get-Disk | ForEach-Object {
    @{
        FriendlyName = $_.FriendlyName
        Size = $_.Size 
        Path = $_.Path
        OperationalStatus = $_.OperationalStatus.ToString()
    }
}
}