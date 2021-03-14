function Set-MimecastAppInfo {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory)]
        [string]$AppId,
        [Parameter(Mandatory)]
        [string]$AppKey
    )

    $Path = "$ENV:APPDATA\PSMimecast\AppInfo.xml"
        if (!(Test-Path -Path $Path)){
            $AppInfo = [PSCustomObject]@{
                AppId = $AppId
                AppKey = (ConvertTo-SecureString $AppKey -AsPlainText -Force | ConvertFrom-SecureString)
            }
            $AppInfo | Export-Clixml -Path $Path
        }
}