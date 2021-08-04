Import-Module UniversalDashboard
Import-Module "$PSScriptRoot/../output/UniversalDashboard.Style/UniversalDashboard.Style.psd1" -Force

$Dashboard = New-UDDashboard -Title "Style Test" -Content {
    New-UDStyle -Style '
    padding: 32px;
    background-color: hotpink;
    font-size: 24px;
    border-radius: 4px;
    &:hover {
      color: white;
    }
    .card {
        background-color: green !important;   
    }' -Content {
        New-UDCard -Title 'Test' -Content {
            "Hello"
        }
    }
}

Start-UDDashboard -Port 10001 -Dashboard $Dashboard -Force