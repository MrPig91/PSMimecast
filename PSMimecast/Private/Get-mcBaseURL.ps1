function Get-mcBaseURL {
    [CmdletBinding()]
    param()

    try{
        $region = (Get-MimecastRegion).Region
        return "https://$region-api.mimecast.com"
    }
    catch{
        $PSCmdlet.WriteError($_)
    }
}