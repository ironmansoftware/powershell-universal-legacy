$Processes = Get-Process | Select-Object Name, ID
Set-PSUCache -Key "Processes" -value $Processes