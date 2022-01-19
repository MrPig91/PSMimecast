<#
.SYNOPSIS
    This function will get messages that are under moderatoin review to be rejected or released.
.DESCRIPTION
    This function will get messages that are under moderatoin review to be rejected or released.
    This function is equivalent of going to Administration -> Message Center -> and selecting held reason category in the web UI.
.PARAMETER reasonCode
    This parameter should return only messages that match the reasonCode supplied, however I think their API does not support this.
.PARAMETER subject
    This parameter will return all held messages that have the subject field matching the string provided.
.PARAMETER sender1
    This parameter will return all held messages that have the sender field matching the string provided. The parameter uses sender1 since the variable sender is an automatic function and should not be used.
.PARAMETER recipient
    This parameter will return all held messages that have the recipient field matching the string provided.
.PARAMETER all
    This parameter will return all held messages that contain the provided string in any of the message's properties (subject, sender, recipeint, reasonCode).
.PARAMETER admin
    This parameter determines the level of results to return. If false, only results for the currenlty authenticated user will be returned. If true, held messages for all recipients will be returned. The default value is false.
    The default value is True.
.PARAMETER start
    This parameter will return all held messages that were receivied after the date and time provided. Use tab to launch the GUI to selecte a date and time.
.PARAMETER end
    This parameter will return all held messages that were receivied before the date and time provided. Use tab to launch the GUI to selecte a date and time.
.PARAMETER PageSize
    This parameter specifies how many held messages are return by each query. The default value is 50 and max value is 500.
.EXAMPLE
    PS C:\> Get-mcHeldMessage -recipient syrius.cleveland

    From                           To                   subject                                  route    Held Reason               HasAttachments   DateReceived
    ----                           --                   -------                                  -----    -----------               --------------   ------------
    Spiceworks                     Syrius Cleveland     Need a new hobby for 2022? Check out ... INBOUND  Agressive Spam Detection  False            12/28/2021 7:57:50 PM

    This example gets all the held messages for receipient syrius.cleveland for the last 24 hours.
.INPUTS
    None
.OUTPUTS
    PSMimecast.HeldMessage
.NOTES
    I do not believe the reasonCode parameter works, but I included since it is the documenation provided by Mimecast.
#>
function Get-MimecastHeldMessage {
    [cmdletbinding()]
    [Alias("Get-mcHeldMessage")]
    Param(
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
        [string]$start = (Get-Date).AddDays(-1).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss+0000"),
        [ArgumentCompleter({
            param ($commandName,$parameterName,$wordToComplete,$commandAst,$fakeBoundParameters)
            Get-MimecastDateTime
        })]
        [string]$end = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss+0000"),

        [ValidateRange(1,500)]
        [int]$PageSize = 50
    )

    Begin{
        $baseUrl = "https://us-api.mimecast.com"
        $apiCall = "/api/gateway/get-hold-message-list"
        $url = $baseUrl + $apiCall

        $searchBy = @{}
        $data = @{}
        $meta = @{
            pagination = @{
                pageSize = $PageSize
             }
        }

        $CommonParameters = [System.Management.Automation.Internal.CommonParameters].DeclaredProperties.Name
        $Parameters = $MyInvocation.MyCommand.Parameters.Keys | where {$_ -notin $CommonParameters}

        $SearchParam = @("all","subject","sender1","recipient","reason_code")
        $dataParam = @("admin","start","end")
        foreach ($param in $Parameters){
            $value = (Get-Variable -Name $param).Value
            if (![String]::IsNullOrEmpty($value)){
                if ($param -in $SearchParam){
                    $searchBy["fieldName"] = $param.TrimEnd('1')
                    $searchBy["value"] = $value.ToString()
                }
                elseif ($param -in $dataParam){
                    $data[$param] = $value.ToString()
                }
            }
        }
        
        if ($searchBy.Keys -ne $null){
            $data["searchBy"] = $searchBy
        }
    } #Begin

    Process{
        $headers = New-MimecastHeader -Uri $apiCall

        #Create post body
        $postBody = @{
            meta = $meta
            data = @($data)
        } | ConvertTo-Json -Depth 3
        #Send Request
        $response = Invoke-MimecastAPI -Method Post -Headers $headers -Body $postBody -Uri $url
        #Print the response
        if ($response.fail){
            Write-Error "$($response.fail.errors.message)"
        }
        else{
            $message = $response.data
            foreach ($message in $response.data){
                $message | Add-Member -Name ReleaseMessage -MemberType ScriptMethod -Value {New-HeldMessageReleaseAction -Id $this.Id}
                $message.dateReceived = [datetime]::Parse($message.dateReceived)
                $message | Add-Member -TypeName "PSMimecast.HeldMessage"
                $message
            }
        }
    } #Process
}
