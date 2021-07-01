New-PSUEnvironment -Name "7.1.0" -Path "C:\Program Files\PowerShell\7\pwsh.exe" -Variables @('*') 
New-PSUEnvironment -Name "5.1.19041.1023" -Path "C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe" -Variables @('*') 
New-PSUEnvironment -Name "Integrated" -Path "PowerShell Version: 7.1.3" -Variables @('*') 
New-PSUEnvironment -Name "Persistent" -Path "pwsh.exe" -PersistentRunspace