<#
.SYNOPSIS
    This function will create a new file (or overwrite an existing one) and store the API key that will used by other functions in this module to authenticate with the Mimecast API.
.DESCRIPTION
    This function will create a new file (or overwrite an existing one) and store the API key that will used by other functions in this module to authenticate with the Mimecast API.
.PARAMETER AppId
    This is the AppId string of the custome app integration you setup in the Mimecast web UI.
.PARAMETER Credentials
    This parameter will use the credentials passed to it to authenticate with Mimecast.
.PARAMETER AuthType
    This parameter specifies the authentication method to use with the provided credentials. If they are credentials to your AD account, then use "Basic-AD", otherwise setup a cloud password and use "Basic-Cloud".
.EXAMPLE
    PS C:\> New-MimecastAPIKeys -AppId XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX -AuthType Basic-Cloud -Credentials (Get-Credential)

    This examples creates a new API key and stores it in file to be used by the rest of the module. Nothing is returned.
.INPUTS
    None
.OUTPUTS
    None
.NOTES
    This function can be used to overwrite your existing API keys. You cannot use more than one API key with this module.
#>
function New-MimecastAPIKeys {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory)]
        $AppId,
        [Parameter(Mandatory)]
        [pscredential]$Credentials,
        [ValidateSet("Basic-Cloud","Basic-Ad")]
        $AuthType = "Basic-Cloud"
    )

    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $apiCall = "/api/login/login"
        $url = $baseUrl + $apiCall

        #Generate request header values
        $hdrDate = (Get-Date).ToUniversalTime().ToString("ddd, dd MMM yyyy HH:mm:ss UTC") 
        $requestId = [guid]::NewGuid().guid
    }

    Process{	
        $EmailAddress = $Credentials.UserName
        $password = $Credentials.GetNetworkCredential().Password
        $headers = @{
            "Authorization" = $authType + " " + [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($emailAddress + ":" + $password));
            "x-mc-date" = $hdrDate;
            "x-mc-app-id" = $AppId;
            "x-mc-req-id" = $requestId;
            "Content-Type" = "application/json"
        }
        #Create post body
        $postBody = @{
            data = @(@{
                userName = $emailAddress
            })
        }
        $postBody = $postBody | ConvertTo-Json
        #Send Request
        $response = Invoke-MimecastAPI -Method Post -Headers $headers -Body $postBody -Uri $url
        #Print the response
        if ($response.data.accesskey){
            Set-MimecastAPIKeys -AccessKey $response.data.accesskey -SecretKey $response.data.secretKey -Email $EmailAddress -AuthType $AuthType
        }
        else{
            Write-Error -Message "Unable to create keys: $($response.fail.errors.message)"
        }
    } #Process
}