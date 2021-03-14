function New-HeldMessageRejectAction{
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory)]
        [Alias("Id")]
        [string[]]$MessageId,
        [string]$message,
        [string]$reasonType,
        [bool]$nofify

    )

    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $uri = "/api/gateway/hold-reject"
        $url = $baseUrl + $uri

        $SkipParamerters = @("MessageId")
        $data = @{ids = $MessageId}
        $PSBoundParameters.Keys | where {$_ -notin $SkipParamerters} | foreach{
            $data[$_] = $PSBoundParameters[$_]
        }
        $dataJson = $data | ConvertTo-Json
    }

    Process{
        $headers = New-MimecastHeader -Uri $Uri

        $postBody = "{
            ""data"": [
                $dataJson
            ]
        }"

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