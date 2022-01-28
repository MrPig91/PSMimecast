<#
.SYNOPSIS
    This function will return the profile of a specified Mimecast user.
.DESCRIPTION
    This function will return the profile of a specified Mimecast user.
    This function is equivalent to going to Administration -> Interal Directories -> <Domain> -> and selecting a user in the web UI.
    Some fields are missing like whether the account is locked or disabled, and Get-MimecastAccount should be used if these properties are needed.
.PARAMETER EmailAddress
    This parameter specifies the email address of the user profile to return.
.EXAMPLE
    PS C:\> Get-MimecastProfile -EmailAddress syrius.cleveland@example.com

    name           : Syrius Cleveland
    emailAddress   : syrius.cleveland@example.com
    links          : {@{name=avatar; method=GET; uri=http://us-api.mimecast.com/...
    attributes     : @{phoneNumber=}
    localPassword  : True
    changePassword : True
    external       : False
    editable       : False
    role           : Full Administrator
    companyName    : Example Company
    serverTimeZone : America/New_York
    id             : syrius.cleveland@example.com
    accountCode    : XXXXXXX
    admin          : True

    This example returns the profile of the user with the email address syrius.cleveland@example.com.
.INPUTS
    string
        EmailAddress
.OUTPUTS
    PSCustomObject
.NOTES
    Some fields are missing like whether the account is locked or disabled, and Get-MimecastAccount should be used if these properties are needed.
#>
function Get-MimecastProfile {
    [cmdletbinding()]
    [Alias("Get-mcProfile")]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string]$EmailAddress
    )

    Begin{
        $baseUrl = Get-mcBaseURL
        $apiCall = "/api/user/get-profile"
        $url = $baseUrl + $apiCall
    }
    
    Process{
        $headers = New-MimecastHeader -Uri $apiCall

        #Create post body
        $postBody = @{
            data = @(@{
                emailAddress = $emailAddress
                showAvatar = "False"
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