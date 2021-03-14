function Invoke-MimecastAPI{
    [cmdletbinding()]
    param(
        $Method,
        $Uri,
        $headers,
        $Body
    )

    try{
        Write-Information "Sending API Request to $uri"
        $response = Invoke-RestMethod @PSBoundParameters
    }
    catch [System.Net.WebException]{
        Write-Information "A System.Net.WebException has occurred"
        if ($_.Exception.Message -like "*418*"){
            Write-Warning "Your API Access has expired. Use Update-MimecastExpiredAccessKey to update your expired AccessKey"
            if ((Read-Host "Would you like to Update your API Access key (Y/N)?") -like "Y*"){
                Update-MimecastExpiredAccessKey | Out-Null
                if ($?){
                    $response = Invoke-RestMethod @PSBoundParameters
                }
            }
        }
        elseif ($_.Exception.Message -like "*401*"){
            $errorresponse = $_.ErrorDetails.message | ConvertFrom-Json
            $email = $errorresponse.fail.key.username
            $message = $errorresponse.fail.errors.message
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                        [System.Security.Authentication.InvalidCredentialException]::new($message),
                        'InvalidCredentialException',
                        [System.Management.Automation.ErrorCategory]::AuthenticationError,
                        $email
                    )
            throw $ErrorRecord
        }
    }
    catch{
        Write-Information "An unknown error has occurred"
        $PSCmdlet.WriteError($_)
    }

    return $response
}