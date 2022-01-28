function Set-MimecastRegion {
    [Alias("Set-mcRegion")]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet("eu","de","us","ca","za","au","je")]
        [string]$Region
    )

    try{
        $Path = "$ENV:APPDATA\PSMimecast"
        if (!(Test-Path -Path $Path)){
            New-Item -Path $Path -ItemType Directory -Force | Out-Null
        }

        $RegionObject = @{
            Region = $Region
        }
        $RegionObject | Export-Clixml -Path "$Path\Region.xml" -Force
    }
    catch{
        $PSCmdlet.WriteError($_)
    }
}