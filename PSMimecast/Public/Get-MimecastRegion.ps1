function Get-MimecastRegion {
    [Alias("Get-mcRegion")]
    [CmdletBinding()]
    param()

    $Path = "$ENV:APPDATA\PSMimecast\Region.xml"
    if (Test-Path -Path $Path){
        Import-Clixml -Path $Path
    }
    else{
        throw "Region not set! Use New-MimecastAPIKeys or Set-MimecastRegion to set a region to use for API calls!"
    }
}