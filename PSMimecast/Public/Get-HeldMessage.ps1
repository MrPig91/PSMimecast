function Get-HeldMessage {
    [cmdletbinding()]
    Param(
        [ValidateSet("all","internal","outbound","inbound","external")]
        [string]$route,
        [ValidateSet("administrator","moderator","user","cluster")]
        [string]$heldGroup,
        [bool]$attachments,
        [string]$reasonCode,
        [string]$subject,
        [Alias("Sender")]
        [string]$sender1,
        [string]$recipient,
        [string]$all,
        [bool]$admin = $true,
        [ArgumentCompleter({
            param ($commandName,$parameterName,$wordToComplete,$commandAst,$fakeBoundParameters)
            Get-MimecastDateTime
        })]
        [string]$start,
        [ArgumentCompleter({
            param ($commandName,$parameterName,$wordToComplete,$commandAst,$fakeBoundParameters)
            Get-MimecastDateTime
        })]
        [string]$end
    )

    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $uri = "/api/gateway/get-hold-message-list"
        $url = $baseUrl + $uri

        $searchBy = @{}
        $filterBy = @{}
        $data = @{}

        $CommonParameters = [System.Management.Automation.Internal.CommonParameters].DeclaredProperties.Name
        $Parameters = $MyInvocation.MyCommand.Parameters.Keys | where {$_ -notin $CommonParameters}

        $filterParam = @("route","heldGroup","attachments")
        $SearchParam = @("all","subject","sender1","recipient","reason_code")
        $dataParam = @("admin","start","end")
        foreach ($param in $Parameters){
            $value = (Get-Variable -Name $param).Value
            if (![String]::IsNullOrEmpty($value)){
                if ($param -in $filterParam){
                    $filterBy["fieldName"] = $param
                    $filterBy["value"] = $value.ToString()
                }
                elseif ($param -in $SearchParam){
                    $searchBy["fieldName"] = $param.TrimEnd('1')
                    $searchBy["value"] = $value.ToString()
                }
                elseif ($param -in $dataParam){
                    $data[$param] = $value.ToString()
                }
            }
        }
        
        if ($filterBy.Keys -ne $null){
            $data["filterBy"] = $filterBy
        }
        if ($searchBy.Keys -ne $null){
            $data["searchBy"] = $searchBy
        }
        $dataJson = $data | ConvertTo-Json
    } #Begin

    Process{
        $headers = New-MimecastHeader -Uri $Uri

        #Create post body
        $postBody = "{
                            ""data"": [
                                $dataJson
                            ]
                        }"

        #Send Request
        $response = Invoke-MimecastAPI -Method Post -Headers $headers -Body $postBody -Uri $url
        #Print the response
        if ($response.fail){
            Write-Error $response.fail.errors.message
        }
        else{
            $message = $response.data
            $message | Add-Member -Name ReleaseMessage -MemberType ScriptMethod -Value {New-HeldMessageReleaseAction -Id $this.Id}
            $message | Add-Member -TypeName "Mimecast.HeldMessage"
            $message
        }
    } #Process
}
