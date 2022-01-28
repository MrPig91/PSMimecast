<#
.SYNOPSIS
    This function is used to reject a currently held message.
.DESCRIPTION
    This function is used to reject a currently held message.
    This function is equivalent to navigating to Administration -> Held Message -> Selecting a message and clicking the "reject" button in the web UI.
.PARAMETER MessageId
    This parameter specifies the Id of the message that will be rejected.
.PARAMETER message
    This parameter provides a message to be returned to the sender.
.PARAMETER reasonType
    This parameter specifies the reason code for the message being rejected.
    Possible values are: MESSAGE CONTAINS UNDESIRABLE CONTENT, MESSAGE CONTAINS CONFIDENTIAL INFORMATION,
    REVIEWER DISAPPROVES OF CONTENT, INAPPROPRIATE COMMUNICATION, MESSAGE GOES AGAINST EMAIL POLICIES
.PARAMETER notify
    This parameter indicates whether or not to Deliever a rejection notification to the sender. Default value is false.
.EXAMPLE
    PS C:\> Get-MimecastHeldMessage -recipient syrius.cleveland | where policyinfo -eq "Agressive Spam Detection" |
     New-HeldMessageRejectAction -reasonType 'REVIEWER DISAPPROVES OF CONTENT' -nofify $true -message "Message was rejected due to spam."

    id                      reject
    --                      ------
    XXXXXXXXXXXXXXXXX....   True

    This example gets all held messages for syrius.cleveland and filters for only messages with the PolicyInfo equal to "Agressive Spam Detection".
    These held messages are then piped to New-HeldMessageRejectAction function to be rejected with a reason give and message for more information.
    An object is rertun to confirm this rejection was successful and provides the Id of the held message that was rejected.
.INPUTS
    string
        MessageId
.OUTPUTS
    PSCustomObject
.NOTES
    You can provide an array of Ids to be rejected. 
#>
function New-HeldMessageRejectAction{
    [cmdletbinding()]
    [Alias("Invoke-mcRejectMessage")]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [string[]]$MessageId,
        [string]$message,
        [ValidateSet("MESSAGE CONTAINS UNDESIRABLE CONTENT", "MESSAGE CONTAINS CONFIDENTIAL INFORMATION", "REVIEWER DISAPPROVES OF CONTENT",
         "INAPPROPRIATE COMMUNICATION", "MESSAGE GOES AGAINST EMAIL POLICIES")]
        [string]$reasonType,
        [bool]$nofify

    )

    Begin{
        $baseUrl = Get-mcBaseURL
        $apiCall = "/api/gateway/hold-reject"
        $url = $baseUrl + $apiCall
        $SkipParamerters = @("MessageId")
    }

    Process{
        $headers = New-MimecastHeader -Uri $apiCall

        $data = @{ids = $MessageId}
        $PSBoundParameters.Keys | where {$_ -notin $SkipParamerters} | foreach{
            $data[$_] = $PSBoundParameters[$_]
        }

        $postBody = @{data = @($data)} | ConvertTo-Json -Depth 5

        #Send Request
        $response = Invoke-MimecastAPI -Method Post -Headers $headers -Body $postBody -Uri $url

        #Print the response
        if ($response.fail){
            Write-Error $response.fail.errors.message
        }
        else{
            $response.data
        }
    } #Process
}