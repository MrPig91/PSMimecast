<#
.SYNOPSIS
    This function will get information of a Mimecast account.
.DESCRIPTION
    This function will get information of a Mimecast account including if the account is locked or disabled.
    This is equivalent to going to Administration -> Directories -> Internal Directories -> <domain> -> and picking a user in the web UI.
.PARAMETER EmailAddress
    This parameter specifies the email address of the user you want get information about.
.EXAMPLE
    PS C:\> Get-MimecastAccount -EmailAddress syrius.cleveland@example.com

    Name             EmailAddress                    accountLocked AccountDisabled AllowSmtp AllowPop PasswordNeverExpires ForcePasswordChange
    ----             ------------                    ------------- --------------- --------- -------- -------------------- -------------------
    Syrius Cleveland syrius.cleveland@example.com    False          False        False    False          False                False

    In this example we get the account information for the user syrius.cleveland@example.com. We can see his account is not locked and not disabled.
.INPUTS
    string
        EmailAddress
.OUTPUTS
    spz.Mimecast.Account
.NOTES
    This function actually calls the Update API call wihtout any changes to retrieve this information.
#>
function Get-MimecastAccount{
    [cmdletbinding()]
    [Alias("Get-mcAccount")]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [Alias("User","Email")]
        [string]$EmailAddress
    )

    Begin{
        $baseUrl = Get-mcBaseURL
        $apiCall = "/api/user/update-user"
        $url = $baseUrl + $apiCall
    }

    Process{
        $headers = New-MimecastHeader -Uri $apiCall

        $postBody = @{
            data = @(@{
                emailAddress = $EmailAddress
            })
        }
        $postBodyJson = $postBody | ConvertTo-Json

        #Send Request
        $response = Invoke-MimecastAPI -Method Post -Headers $headers -Body $postBodyJson -Uri $url
        
        #Print the respons
        if ($response.data){
            $response.data | ForEach-Object {
                $_ | Add-Member -TypeName "PSMimecast.Account"
                $_
            }
        }
        else{
            Write-Error "$($response.fail.errors.message)"
        }
    }
}