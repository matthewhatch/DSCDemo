####Session Setup

$Cred = Get-Credential
$Session = New-CimSession -ComputerName 'localhost' -Port 55985 -Credential $Cred 


#Load the configuration into memory
Push-Location C:\_demo
. .\DemoConfiguration.ps1

#This is the name of the configuration
WebServer
Start-DscConfiguration -CimSession $Session -Path .\WebServer -Wait -Verbose

#Custom Cmdlet to simulate the SchdTask that runs to update the Configuration
Update-LCMConfiguration -ComputerName localhost -Port 55985 -Credential $cred -Verbose

#This will update the LCM to ApplyandAutoCorrect
#LocalConfiguration Manager Configuration
Configuration LCMConfig{
    Node 'localhost'{
        LocalConfigurationManager{
            ConfigurationMode = "ApplyAndAutocorrect"
        }
    }
}

LCMConfig
Set-DscLocalConfigurationManager -CimSession $Session -Path .\LCMConfig 


Pop-Location

 $Session = New-PSSession -ComputerName localhost -Port 55985 -Credential (Get-Credential)