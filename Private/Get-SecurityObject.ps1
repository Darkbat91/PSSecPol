function Get-SecurityObject {
    <#
    .Synopsis
    HELPER - Gets security policy from the local system
    .DESCRIPTION
    Returns an object with the local security policy for use in other functions
    #>
    [CmdletBinding()]
    [Alias('gsp')]
    [OutputType([int])]
    #region Variables
    $Workingdir = "$env:TEMP"
    $configfile = "$Workingdir\secpol.ini"
    [regex]$Headingregex = '\[.*\]'

    $SecurityObject = @()
    #endregion Variables


    $returncode = Start-Process -FilePath secedit -ArgumentList "/export /cfg $configfile /quiet" -PassThru -Wait -NoNewWindow

    #Failed to Export policy
    if ($returncode.ExitCode -ne 0) {
        Write-Error 'Failed to export policy'
        return
    }

    $SecurityContent = Get-Content -Path $configfile
    foreach ($line in $SecurityContent) {
        if ($line -match $Headingregex) {
            # If we are a Heading update it!
            $Heading = $line
            continue
        }
        else # We are a member of a policy {
        $Values = $line -split '='
    }

    $Props = @{
        'heading' = $Heading.Replace('[', '').replace(']', '')
        'Setting' = $Values[0].trim()
        'Value'   = $Values[1].trim()
    }
    $SecurityObject += New-Object -TypeName PSOBJECT -Property $props
}





#region Cleanup
Remove-Item $configfile -Force -Confirm:$false

#endregion
return $SecurityObject
}