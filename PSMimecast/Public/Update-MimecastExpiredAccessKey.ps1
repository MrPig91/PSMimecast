function Update-MimecastExpiredAccessKey {
    param(
        [Parameter(Mandatory)]
        [SecureString]$Password,
        [ValidateSet("Basic-Cloud","Basic-Ad")]
        $AuthType = "Basic-Ad"
    )
    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $uri = "/api/login/login"
        $url = $baseUrl + $uri

        $Keys = Get-MimecastAPIKeys
        $Appinfo = Get-MimecastAppInfo
        $accessKey = $Keys.AccessKey
        $appId = $Appinfo.AppId
        $emailAddress = $keys.EmailAddress
    }

    Process{ 	
        $hdrDate = (Get-Date).ToUniversalTime().ToString("ddd, dd MMM yyyy HH:mm:ss UTC")
        $requestId = [guid]::NewGuid().guid
        $cred = [pscredential]::new("Test",$Password)
        $pass = $cred.GetNetworkCredential().Password
        $headers = @{"Authorization" = $authType + " " + [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($emailAddress + ":" + $pass));
        "x-mc-date" = $hdrDate;
        "x-mc-app-id" = $appId;
        "x-mc-req-id" = $requestId;
        "Content-Type" = "application/json"}

        #Create post body
        $postBody = "{
        ""data"": [
            {
                ""userName"": " + $emailAddress + ",
                ""accessKey"": " + $accessKey + "
            }
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