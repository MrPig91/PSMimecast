function Get-MimecastAppInfo {
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