function New-UDPingForm {
    New-UDForm -Content {
      New-UDTextbox -Id 'txtComputer' -Label 'Computer or Address' 
    } -OnSubmit {
       $Data = Test-NetConnection -ComputerName $EventData.txtComputer | Select-Object -Property ComputerName,NameResolutionSucceeded,PingSucceeded
       New-UDTable -Data $Data
    }
}