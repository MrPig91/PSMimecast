function Get-MimecastAPIKeys {
    $Path = "$ENV:APPDATA\PSMimecast\Keys.xml"
    if (Test-Path -Path $Path){
        $SecretObject = Import-Clixml -Path $Path
        [PSCustomObject]@{
            AccessKey = [pscredential]::new("API",(ConvertTo-SecureString -String $SecretObject.AccessKey)).GetNetworkCredential().Password
            SecretKey = [pscredential]::new("API",(ConvertTo-SecureString -String $SecretObject.SecretKey)).GetNetworkCredential().Password
            EmailAddress = $SecretObject.EmailAddress
            AuthType = $SecretObject.AuthType
        }
    }
    else{
        Write-Error "Keys have not been set, use New-MimecastAPIKeys to set the keys" -ErrorAction Stop
    }
}