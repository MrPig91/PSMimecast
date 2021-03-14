function Get-MimecastDirectoryConnection{
    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $uri = "/api/directory/get-connection"
        $url = $baseUrl + $uri
    }

    Process{
        $headers = New-MimecastHeader -Uri $Uri

        #Create post body
        $postBody = "{
            ""data"": [
            ]
        }"

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