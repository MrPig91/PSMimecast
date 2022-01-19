<#
.SYNOPSIS
    This function unlocks a Mimecast account that is currently locked.
.DESCRIPTION
    This function unlocks a Mimecast account that is currently locked. It does this by setting the property "accountLocked" to False.
.PARAMETER EmailAddress
    This parameter specifies the email address of the Mimecast account you want to unlock.
.EXAMPLE
    PS C:\> Unlock-MimecastAccount -EmailAddress syrius.cleveland@example.com

    emailAddress         : syrius.cleveland@example.com
    name                 : Syrius Cleveland
    forcePasswordChange  : False
    passwordNeverExpires : False
    accountLocked        : False
    accountDisabled      : False
    allowSmtp            : False
    allowPop             : False

    This example unlocks the Mimecast account with the email address of syrius.cleveland@example.com.
    The object of this account is returned and we can confirm the account is now unlocked by looking at the accountLocked property on this object.
.INPUTS
    string
        EmailAddress
.OUTPUTS
    PSCustomObject
.NOTES
    General notes
#>
function Unlock-MimecastAccount{
    [cmdletbinding()]
    [Alias("Unlock-mcAccount")]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        $EmailAddress
    )

    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $apiCall = "/api/user/update-user"
        $url = $baseUrl + $apiCall
    }

    Process{
        $headers = New-MimecastHeader -Uri $apiCall

        $postBody = @{
            data = @(@{
                accountLocked = "False"
                emailAddress = $EmailAddress
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
    } #Process
}