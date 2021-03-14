function Get-HeldMessageSummary {

    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $uri = "/api/gateway/get-hold-summary-list"
        $url = $baseUrl + $uri
    }
    
    Process{
        $headers = New-MimecastHeader -Uri $Uri

        #Create post body
        $postBody = "{
                            ""data"": []
                        }"

        #Send Request
        $response = Invoke-MimecastAPI -Method Post -Headers $headers -Body $postBody -Uri $url

        #Print the response
        $response.data
    }
}