function New-MimecastAPIKeys {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory)]
        $AppId,
        [Parameter(Mandatory)]
        [pscredential]$Credentials,
        [ValidateSet("Basic-Cloud","Basic-Ad")]
        $AuthType = "Basic-Ad"
    )

    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $uri = "/api/login/login"
        $url = $baseUrl + $uri

        #Generate request header values
        $hdrDate = (Get-Date).ToUniversalTime().ToString("ddd, dd MMM yyyy HH:mm:ss UTC") 
        $requestId = [guid]::NewGuid().guid
    }

    Process{	
        $EmailAddress = $Credentials.UserName
        $password = $Credentials.GetNetworkCredential().Password
        $headers = @{"Authorization" = $authType + " " + [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($emailAddress + ":" + $password));
                "x-mc-date" = $hdrDate;
                "x-mc-app-id" = $AppId;
                "x-mc-req-id" = $requestId;
                "Content-Type" = "application/json"}
        #Create post body
        $postBody = "{
                        ""data"": [
                            {
                                ""userName"": " + $emailAddress + "
                            }
                        ]
                        }"
        #Send Request
        $response = Invoke-MimecastAPI -Method Post -Headers $headers -Body $postBody -Uri $url
        #Print the response
        if ($response.data.accesskey){
            Set-MimecastAPIKeys -AccessKey $response.data.accesskey -SecretKey $response.data.secretKey -Email $EmailAddress
        }
        else{
            Write-Error "Unable to create keys" -ErrorAction Stop
        }
    }
}