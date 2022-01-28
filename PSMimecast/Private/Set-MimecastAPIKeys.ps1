function Set-MimecastAPIKeys{
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory)]
        $AccessKey,
        [Parameter(Mandatory)]
        $SecretKey,
        $EmailAddress,
        $AuthType
    )

    Begin{
        $Path = "$ENV:APPDATA\PSMimecast"
        if (!(Test-Path -Path $Path)){
            New-Item -Path $Path -ItemType Directory -Force | Out-Null
        }
    } #Begin

    Process{
        $SecureAccessKey = ConvertTo-SecureString $AccessKey -AsPlainText -Force
        $SecureSecretKey = ConvertTo-SecureString $SecretKey -AsPlainText -Force

        $EncryptedAccessKey = ConvertFrom-SecureString -SecureString $SecureAccessKey
        $EncryptedSecureKey = ConvertFrom-SecureString -SecureString $SecureSecretKey

        $SecretObject = [PSCustomObject]@{
            AccessKey = $EncryptedAccessKey
            SecretKey = $EncryptedSecureKey
            EmailAddress = $EmailAddress
            AuthType = $AuthType
        }

        $SecretObject | Export-Clixml -Path "$Path\Keys.xml" -Force
    } #Process
}