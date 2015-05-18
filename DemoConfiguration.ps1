Configuration WebServer
{
    
    Import-DscResource -ModuleName cWebAdministration_1.2
    
    Node 'localhost'
    {
        
        WindowsFeature 'WebServer'
        {
            Ensure = 'Present'
            Name = 'Web-Server'
        }

        
        Service 'www'{
            Name = 'w3svc'
            State = 'Running'
            StartUpType = 'Automatic'
            DependsOn = "[WindowsFeature]WebServer"    
        }
        

        cWebSite 'RemoveDefault'
        {
            Name = 'Default Web Site'
            Ensure = 'Absent'
            PhysicalPath = 'c:\inetpub\wwwroot'
            DependsOn = "[Service]www"
        }

        File 'WebSites'
        {
            Ensure = 'Present'
            Type = 'directory'
            DestinationPath = 'c:\WebSites\LegoMovie'
        }

        cWebSite 'LegoMovie'
        {
            Name = 'LegoMovie'
            Ensure = 'Present'
            PhysicalPath = 'c:\websites\LegoMovie'
            State = 'Started'
            DependsOn = "[cWebSite]RemoveDefault"    
        }
        
        File 'Default Web Page'
        {
            Ensure = 'Present'
            Type = 'File'
            DestinationPath = 'C:\websites\LegoMovie\default.htm'
            Contents = '<h1>Everything is Awesome!</h1>'
            DependsOn = "[File]WebSites" 
        }

        
        Service 'bits'{
            Name = 'bits'
            State = 'Stopped'
        }
        
    }

}
