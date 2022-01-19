<#
.SYNOPSIS
    This function will initiate directory synchronization of all connected directories.
.DESCRIPTION
    This function will initiate directory synchronization of all connected directories.
    This function is equivalent to navigating to Administration -> Services - Directory Synchronization -> and click "Sync Directory Data" in the web UI.
.EXAMPLE
    PS C:\>Start-MimecastDirectorySync

    type             syncStatus
    ----             ----------
    ACTIVE_DIRECTORY started

    This example starts the directory synchronization process and the return object confirms that execution was successful.
.INPUTS
    None
.OUTPUTS
    PSCustomObject
.NOTES
    This function may take some time to process, be patient when you call this function.
#>
function Start-MimecastDirectorySync{
    [CmdletBinding()]
    [Alias("Start-mcDirectorySync")]
    param()
    Begin{   	
        $baseUrl = "https://us-api.mimecast.com"
        $apiCall = "/api/directory/execute-sync"
        $url = $baseUrl + $apiCall
    }

    Process{
        $headers = New-MimecastHeader -Uri $apiCall
        #Create post body
        $postBody = @{data = @()} | ConvertTo-Json
        #Send Request
        $response = Invoke-MimecastAPI -Method Post -Headers $headers -Body $postBody -Uri $url

        #Print the respons
        if ($response.data){
            $response.data
        }
        else{
            Write-Error "$($response.fail.errors.message)"
        }
    } #Process
}