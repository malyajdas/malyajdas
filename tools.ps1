$MDErrorlogPreference = "F:\script\error.txt"

function Get-MDSystemInfo {
[CmdletBinding()]
    param(    
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Computer name or IP address to query via WMI")]
        [Alias('hostname')]
        [string[]]$computerName,

        [Parameter()]
        [string]$ErrorLogPath = $MDErrorlogPreference
    )
    BEGIN {}
    PROCESS{
         foreach ($computer in $computerName){
            $os = Get-WmiObject -Class win32_operatingsystem -ComputerName $computer
            $cs = Get-WmiObject -Class win32_computersystem -ComputerName $computer
            $prop = @{'computerName'=$computer;
                      'OSVersion'=$os.version;
                      'OSBuild'=$os.buildnumber;
                      'SPversion'=$os.servicepackmajorversion;
                      'Model'=$cs.model;
                      'Manufacturer'=$cs.manufacturer;
                      'RAM GB'=$cs.totalphysicalmemory / 1GB -as [int];
                      'Sockets'=$cs.numberofprocessors;
                      'Cores'=$cs.numberoflogicalprocessors}
            $obj = New-Object -TypeName psobject -Property $prop
            Write-Output $obj
        }
    }
    END{}
}

#Get-MDSystemInfo -host DESKTOP-1SOL1MN, localhost
#'DESKTOP-1SOL1MN', 'localhost' | Get-MDSystemInfo
Import-Csv C:\Temp\computer.csv | Get-MDSystemInfo