<#
.SYNOPSIS
    This function returns the directory connections of Mimecast.
.DESCRIPTION
    This function returns the directory connections of Mimecast.
    This function is equivalent to going to Administration -> Services -> Directory Synchronization in the web UI.
.EXAMPLE
    PS C:\> Get-MimecastDirectoryConnection | Select-Object -First 1

    enabled                     : True
    id                          : MTOKEN:XXXXXXXXXXXXXXXXXXXXXXX...
    description                 : description
    info                        :
    serverType                  : active_directory
    ldapSettings                : @{hostname=example.example...
    status                      : ok
    lastSync                    : 12/29/2021 7:43:30 AM
    syncRunning                 : False
    domains                     :
    acknowledgeDisabledAccounts : True

    This example gets the directory connectors and grabs only the first one that is returned. Here we can see whether the connection sync is running and the last time it ran.
.INPUTS
    None
.OUTPUTS
    PSCustomObject
.NOTES
    No notes to add.
#>
function Get-MimecastDirectoryConnection{
    [CmdletBinding()]
    [Alias("Get-mcDirectoryConnection")]
    param()
    Begin{
        $baseUrl = Get-mcBaseURL
        $apiCall = "/api/directory/get-connection"
        $url = $baseUrl + $apiCall
    }

    Process{
        $headers = New-MimecastHeader -Uri $apiCall

        #Create post body
        $postBody = @{data = @()} | ConvertTo-Json

        #Send Request
        $response = Invoke-MimecastAPI -Method Post -Headers $headers -Body $postBody -Uri $url

        #Print the response
        if ($response.data){
            $response.data | ForEach-Object {
                $_.lastSync = [datetime]$_.lastSync
                $_
            }
        }
        else{
            Write-Error "$($response.fail.errors.message)"
        }
    }
}