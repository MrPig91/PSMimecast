function Lock-MimecastAccount{
    param(
        [Parameter(Mandatory)]
        $EmailAddress
    )

    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $uri = "/api/user/update-user"
        $url = $baseUrl + $uri
    }

    Process{
        $headers = New-MimecastHeader -Uri $Uri

        $postBody = "{
            ""data"": [
                {
                    ""accountLocked"": True,
                    ""emailAddress"": ""$EmailAddress""
                }
            ]
        }"

        #Send Request
        $response = Invoke-MimecastAPI -Method Post -Headers $headers -Body $postBody -Uri $url
        #Print the respons
        if ($response.data){
            $response.data
        }
        else{
            Write-Error "$($response.fail.errors.message)"
        }
    }
}