<#
.SYNOPSIS
    This function retrieves the app info used to communicate with Mimecast's API that was previously stored using Set-MimecastAppInfo.
.DESCRIPTION
    This function retrieves the app info used to communicate with Mimecast's API that was previously stored using Set-MimecastAppInfo.
    This information is stored in the following path, "$ENV:APPDATA\PSMimecast\AppInfo.xml".
.EXAMPLE
    PS C:\> Get-MimecastAppInfo

    AppId                                AppKey
    -----                                ------
    XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX

    This example show the only way to use this function. The app info was successfully retrieved. Actual values have been redacted for this example.
.INPUTS
    None
.OUTPUTS
    PSCustomObject
.NOTES
    App info must have been previously set using Set-MimecastAppInfo.
#>
function Get-MimecastAppInfo {
    [CmdletBinding()]
    [Alias("Get-mcAppInfo")]
    $Path = "$ENV:APPDATA\PSMimecast\AppInfo.xml"
    if (Test-Path -Path $Path){
        $AppInfo = Import-Clixml -Path $Path
        [PSCustomObject]@{
            AppId = $Appinfo.AppId
            AppKey = [pscredential]::new("API",(ConvertTo-SecureString -String $Appinfo.AppKey)).GetNetworkCredential().Password
        }
    }
    else{
        Write-Error "No App Info has been set, use Set-MimecastAppInfo function to set this data" -ErrorAction Stop
    }
}