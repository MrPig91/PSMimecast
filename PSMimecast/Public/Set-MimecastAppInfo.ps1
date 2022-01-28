<#
.SYNOPSIS
    This function is used to initially setup the module by storing the appid and the appkey in an encrypted file to be used by other function.
.DESCRIPTION
    This function is used to initially setup the module by storing the appid and the appkey in an encrypted file to be used by other function.
    The path to the file that is created is the following, "$ENV:APPDATA\PSMimecast\Keys.xml".
    You can find the values needed for the two paramters of this function by navigating to Administration -> Services -> API and Platform Integrations -> Your Application Integrations -> and selecting your app in the web UI.
.PARAMETER AppId
    This parameter specifies the AppId of the custom app integration you created in the Mimecast portal.
.PARAMETER AppKey
    This parameter specifies the AppKey of the custom app integration you created in the Mimecast portal.
.EXAMPLE
    PS C:\> Set-MimecastAppInfo -AppId "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" -AppKey "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    
    This example sets the Mimecast App Info needed to use the rest of the functions in the module with redacted Id and Key.
.INPUTS
    None
.OUTPUTS
    None
.NOTES
    You can find the values needed for the two paramters of this function by navigating to Administration -> Services -> API and Platform Integrations -> Your Application Integrations -> and selecting your app in the web UI.
#>
function Set-MimecastAppInfo {
    [cmdletbinding()]
    [Alias("Set-mcAppInfo")]
    Param(
        [Parameter(Mandatory)]
        [string]$AppId,
        [Parameter(Mandatory)]
        [string]$AppKey
    )

    $Path = "$ENV:APPDATA\PSMimecast"
    if (!(Test-Path -Path $Path)){
        New-Item -Path $Path -ItemType Directory -Force | Out-Null
    }

    $AppInfo = [PSCustomObject]@{
        AppId = $AppId
        AppKey = (ConvertTo-SecureString $AppKey -AsPlainText -Force | ConvertFrom-SecureString)
    }
    $AppInfo | Export-Clixml -Path "$Path\AppInfo.xml" -Force
}