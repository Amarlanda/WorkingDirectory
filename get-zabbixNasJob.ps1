   <#
    .SYNOPSIS
    Wrapper for GCI, works by checking the duration of the last work write on the files being copied to the nas

    .DESCRIPTION
    if the file has more than 5 minutes on its last wirte time then the file has not been succesfully copied to the NAS server
    
    .NOTES
    GCI Wrapper for Nayana
    #>
function Get-ZabbixNasJob
{
    [CmdletBinding()]
 
    Param
    (
        # Madaory for Path, accepts pipeline 
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [String]
        $path = 'C:\windows\help',

        # Param2 help description
        [string]
        $exclude = "*.blabla",

        [string]
        $include = "*.ps1",

        $duration = (Get-Date).addhours(-6)

    )

   
    Process{

        if(-not (test-path $path)){
            write-warning "path $($path) is not accessible"
        }else{
            Write-Host "path $($path) is accessible :) " -ForegroundColor Green
        }

        #$date = (Get-Date).Addminutes(-5)
        #$duration = (Get-Date).addhours(-6)

        
        $files = get-childitem -path $path -recurse -include "$include" -exclude "*.ni.*"| 
        where-object {$_.LastWriteTimeUtc -gt $duration } | 
        select fullname ,LastWriteTimeUtc
        
        
    }
    End
    {
        
        Write-host "measurement for zabbix $($files.count)"

    }  
}