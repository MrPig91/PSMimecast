function New-MimecastHeader{
    param(
        [string]$Uri
    )
    $Keys = Get-MimecastAPIKeys
    $Appinfo = Get-MimecastAppInfo
    $accessKey = $Keys.AccessKey
    $secretKey = $Keys.SecretKey
    $appId = $Appinfo.AppId
    $appKey = $Appinfo.AppKey

    #Generate request header values
    $hdrDate = (Get-Date).ToUniversalTime().ToString("ddd, dd MMM yyyy HH:mm:ss UTC")
    $requestId = [guid]::NewGuid().guid

    #Create the HMAC SHA1 of the Base64 decoded secret key for the Authorization header
    $sha = New-Object System.Security.Cryptography.HMACSHA1
    $sha.key = [Convert]::FromBase64String($secretKey)
    $sig = $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($hdrDate + ":" + $requestId + ":" + $Uri + ":" + $appKey))
    $sig = [Convert]::ToBase64String($sig)
        
    #Create Headers
    $headers = @{
        "Authorization" = "MC $($accessKey): $sig"
        "x-mc-date" = $hdrDate
        "x-mc-app-id" = $appId
        "x-mc-req-id" = $requestId
        "Content-Type" = "application/json"
    }
    
    $headers
}