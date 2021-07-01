New-PSUEndpoint -Url "/service/:name" -Description "Stops a service" -Method "DELETE" -Endpoint {
Stop-Service $Name
} 
New-PSUEndpoint -Url "/service/:name" -Description "Starts a service." -Method "POST" -Endpoint {
Start-Service $Name
} 
New-PSUEndpoint -Url "/service" -Description "Returns the services on this machine. " -Endpoint {
Get-Service | ForEach-Object { 
    @{
        Name = $_.Name
        Status = $_.Status.ToString()
    }
}
} 
New-PSUEndpoint -Url "/process/:name" -Description "Starts a process. " -Method "POST" -Endpoint {
# Try it:  Invoke-RestMethod http://localhost:5000/process/code?arguments=file.txt -Method post
$arg = @{}
if ($Arguments)
{
    $arg = @{
        ArgumentList = $Arguments
    }
}


Start-Process $Name @arg
} 
New-PSUEndpoint -Url "/process" -Description "Returns processes for this machine." -Endpoint {
Get-Process | ForEach-Object { 
    @{
        ID = $_.Id
        Name = $_.Name 
    }
}
}