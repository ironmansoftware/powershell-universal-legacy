Describe "Editor" {
    Context "Editor" {
        Set-TestDashboard {
            New-UDCodeEditor -Id 'editor2' -Language 'powershell' -Theme vs-dark -Code "Get-Process" -ReadOnly -AutoSize
        }
    }
}