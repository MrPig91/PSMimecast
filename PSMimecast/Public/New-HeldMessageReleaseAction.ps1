<#
.SYNOPSIS
    This function can be used to release a currently held messages.
.DESCRIPTION
    This function can be used to release a currently held messages.
    This function is equivalent to navigating to Administration -> Held Message -> Selecting a message and clicking the "release" button in the web UI.
.PARAMETER MessageId
    This parameter specifies the Id of the message that will be released.
.EXAMPLE
    PS C:\> Get-MimecastHeldMessage -recipient syrius.cleveland -start 2021-12-25T22:47:00+0000 | where {$_.from.displayableName -like "*example*"} | New-HeldMessageReleaseAction

    Id              release
    --              -------
    eNpVzF0Lgj7Y... True

    In tis example we get all held messages for syrius.cleveland strating 12/25/2021 and filter for only messages that came from example.
    These held messages are then piped to New-HeldMessageReleaseAction to be release. A return object confirms that the release was successful.
.INPUTS
    string
        MessageId
.OUTPUTS
    PSMimecast.ReleaseMessage
.NOTES
    No notes to add.
#>
function New-HeldMessageReleaseAction{
    [cmdletbinding()]
    [Alias("Invoke-mcReleaseMessage")]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [string]$MessageId
    )

    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $apiCall = "/api/gateway/hold-release"
        $url = $baseUrl + $apiCall
    }

    Process{
        $headers = New-MimecastHeader -Uri $apiCall

        #Create post body
        $postBody = @{data = @(@{id = $MessageId})} | ConvertTo-Json
        #Send Request
        $response = Invoke-MimecastAPI -Method Post -Headers $headers -Body $postBody -Uri $url

        #Print the response
        if ($response.fail){
            Write-Error $response.fail.errors.message
        }
        else{
            $message = $response.data
            $message | Add-Member -TypeName "PSMimecast.ReleaseMessage"
            $message
        }
    }
}