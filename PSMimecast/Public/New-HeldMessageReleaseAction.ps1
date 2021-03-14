function New-HeldMessageReleaseAction{
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [string]$MessageId
    )

    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $uri = "/api/gateway/hold-release"
        $url = $baseUrl + $uri
    }

    Process{
        $headers = New-MimecastHeader -Uri $uri

        #Create post body
        $postBody = "{
            ""data"": [
                {
                    ""id"": ""$MessageId""
                }
            ]
        }"
        #Send Request
        $response = Invoke-MimecastAPI -Method Post -Headers $headers -Body $postBody -Uri $url

        #Print the response
        if ($response.fail){
            Write-Error $response.fail.errors.message
        }
        else{
            $message = $response.data
            $message | Add-Member -TypeName "Mimecast.ReleaseMessage"
            $message
        }
    }
}