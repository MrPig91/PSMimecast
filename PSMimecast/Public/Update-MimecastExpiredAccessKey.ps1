<#
.SYNOPSIS
    This function will refresh an API keys access token if it has expired.
.DESCRIPTION
    This function will refresh an API keys access token if it has expired.
    This function will automatically trigger if another function is called and the Mimecasat server returns a 418 error indicating the current access token has expired.
.PARAMETER Password
    This parameter specifies the the password to use for the authentication process. It should be the same one initially used when creating the API keys.
.EXAMPLE
    PS C:\> Update-MimecastExpiredAccessKey
    
    This example runs the command without the passowrd parameter. The user will be prompted to input a password since that parameter is mandatory.
    Once the password has been entered the function will try to create a new access token to use and store it in a secure file.
.INPUTS
    None
.OUTPUTS
    None
.NOTES
    This function will automatically trigger if a function is called, but gets a 418 error indicating the current access token has expired.

    This re-authentication process was developed using the documenation in the link below.
    https://www.mimecast.com/developer/documentation/authentication-ui-apps/
#>
function Update-MimecastExpiredAccessKey {
    param(
        [Parameter(Mandatory)]
        [SecureString]$Password
    )
    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $apiCall = "/api/login/login"
        $url = $baseUrl + $apiCall

        $Keys = Get-MimecastAPIKeys
        $Appinfo = Get-MimecastAppInfo
        $accessKey = $Keys.AccessKey
        $appId = $Appinfo.AppId
        $emailAddress = $keys.EmailAddress
        $authType = $Keys.AuthType
    }

    Process{ 	
        $hdrDate = (Get-Date).ToUniversalTime().ToString("ddd, dd MMM yyyy HH:mm:ss UTC")
        $requestId = [guid]::NewGuid().guid
        $cred = [pscredential]::new("Test",$Password)
        $pass = $cred.GetNetworkCredential().Password
        $headers = @{
            "Authorization" = $authType + " " + [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($emailAddress + ":" + $pass))
            "x-mc-date" = $hdrDate
            "x-mc-app-id" = $appId
            "x-mc-req-id" = $requestId
            "Content-Type" = "application/json"
        }

        #Create post body
        $postBody = @{
            data = @(@{
                userName = $emailAddress
                accessKey = $accessKey
            })
        }
        $postBody = $postBody | ConvertTo-Json

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