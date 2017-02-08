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
    $Policy = Get-SecurityObject
    }
    Process
    {
        #Verify Setting is correct
        $Settingval = $null
        $Settingval = $Policy | Where-Object -FilterScript {$_.setting -eq $Setting}
        if($Settingval -eq $null -and $AddSetting -ne $true)
            {
            Write-Error "Security Policy `'$value`' Not Valid!"
            continue
            }
        else
            {
            if($Add) # If add we append the value
                {
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