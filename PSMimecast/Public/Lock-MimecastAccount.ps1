<#
.SYNOPSIS
    This function will lock a Mimecast user account.
.DESCRIPTION
    This function will lock a Mimecast user account.
.PARAMETER EmailAddress
    This parameter specifies the emaill address of the account you want to lock.
.EXAMPLE
    PS C:\> Lock-MimecastAccount -EmailAddress syrius.cleveland@example.com

    emailAddress         : syrius.cleveland@example.com
    name                 : Syrius Cleveland
    forcePasswordChange  : False
    passwordNeverExpires : False
    accountLocked        : True
    accountDisabled      : False
    allowSmtp            : False
    allowPop             : False

    This example locks the account with the email address syrius.cleveland@example.com.
.INPUTS
    None
.OUTPUTS
    PSCustomObject
.NOTES
    This function uses the update-user API call to lock the user account.
#>
function Lock-MimecastAccount{
    [cmdletbinding()]
    [Alias("Lock-mcAccount")]
    param(
        [Parameter(Mandatory)]
        $EmailAddress
    )

    Begin{
        $baseUrl = Get-mcBaseURL
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