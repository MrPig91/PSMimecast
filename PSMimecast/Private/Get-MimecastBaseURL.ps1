function Get-MimecastBaseURL {
    [cmdletbinding()]
    Param(
        $UserPrincipalName,
        $AppId
    )

    Begin{
        $baseUrl = "https://api.mimecast.com"
        $uri = "/api/login/discover-authentication"
        $url = $baseUrl + $uri
    }

    Process{	
        #Generate request header values
        $hdrDate = (Get-Date).ToUniversalTime().ToString("ddd, dd MMM yyyy HH:mm:ss UTC")
        $requestId = [guid]::NewGuid().guid

        #Create Headers
        $headers = @{"x-mc-date" = $hdrDate; 
        "x-mc-app-id" = $Appid;
        "x-mc-req-id" = $requestId;
        "Content-Type" = "application/json"}

        #Create post body
        $postBody = "{
        ""data"": [
            {
                ""emailAddress"": $UserPrincipalName
            }
        ]
        }"
        #Send Request
        $response = Invoke-RestMethod -Method Post -Headers $headers -Body $postBody -Uri $url
        #Print the response
        $response
    }
}