function Set-SecurityPolicy
{
<#
.Synopsis
   Sets an Object of the Security Policy
.DESCRIPTION
   Will Set a Value wihin the security Policy
#>
    [CmdletBinding(
    SupportsShouldProcess=$true,
    ConfirmImpact="High")]
    [Alias()]
    Param
    (
        # Setting that is desired to be set
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]$Setting,

        # Value we wish to set
        [Parameter(Mandatory=$true,
                   Position=1)]
        [AllowEmptyString()]
        [string]$Value,
        # If we should just add the value
        [Parameter(Mandatory=$false,
                   Position=1)]
        [switch]$Add,
        # Setting to Add
        [Parameter(Mandatory=$false,
                   Position=1)]
        [switch]$AddSetting,
        # Setting to Add
        [Parameter(Mandatory=$false,
                   Position=1)]
        [ValidateSet('Unicode', 'System Access', 'Event Audit', 'Privilege Rights')]
        [string]$Heading
    )

    Begin
    {
    [regex]$sidregex = "^S-\d-\d+-(\d+-){1,14}\d+$"
    if((Test-IsAdmin) -eq $false)
        {
            Write-Warning "Cant run without admin privliges"
            return
        }
    $Policy = Get-SecurityObject
    }
    Process
    {
        if($Value -notmatch $sidregex)
            {
                $value = get-sid -username $Value
            }
        #Verify Setting is correct
        $Settingval = $null
        $Settingval = $Policy | Where-Object -FilterScript {$_.setting -eq $Setting}
        if($Settingval -eq $null -and $AddSetting -ne $true)
            {
            Write-Error "Security Policy `'$Setting`' Not Valid!"
            continue
            }
        else
            {
            if($Add) # If add we append the value
                {
                    if($Settingval[0].value -contains $Value)
                        {
                            Write-Error -Message "$Value Already exists in $($Settingval.Setting)"
                            return
                        }
                $Settingval[0].Value += $Value
                }
            elseif($AddSetting) # if Add setting then we have to create it new
            {
            $Props = @{
                'heading' = $Heading
                'Setting' = $Setting
                'Value' = $Value
                }

            $Policy += New-Object -TypeName PSOBJECT -Property $props

            }
            else
                {
                $Settingval[0].Value = $Value
                }
            }

    }
    End
    {
        if( $pscmdlet.ShouldProcess("$Setting", "Set the Value to $Value") )
            {
            Write-SecurityPolicy -SecurityObject $Policy
            }
    }
}