<#
.SYNOPSIS
    This function will get the held message summary of all held messages broken up by Reason (or policy Info).
.DESCRIPTION
    This function will get the held message summary of all held messages broken up by Reason (or policy Info).
    This function is equivalent of going to Administration -> Message Center in the web UI.
.EXAMPLE
    PS C:\> Get-MimecastHeldMessageSummary

    policyInfo               numberOfItems
    ----------               -------------
    Agressive Spam Detection          7030

    In this example we can see that there is 7,030 held messages under the Agressive Spam Detection policy and no held messages under any other policies.
.INPUTS
    None
.OUTPUTS
    PSCustomObject
.NOTES
    No notes to add.
#>
function Get-MimecastHeldMessageSummary {
    [CmdletBinding()]
    [Alias("Get-mcHeldMessageSummary")]
    param()
    Begin{
        $baseUrl = Get-mcBaseURL
        $apiCall = "/api/gateway/get-hold-summary-list"
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
            $response.data
        }
        else{
            Write-Error "$($response.fail.errors.message)"
        }
    }
}