function Write-SecurityPolicy {
    <#
    .Synopsis
    HELPER - Writes the Provided Object to the Security Database
    .DESCRIPTION
    Will take the object provided Validate that it is a Security Object and the import it to The WIndows Sec DB
    #>
    [CmdletBinding()]
    [Alias()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory = $true,
            Position = 0)]
        [psobject]$SecurityObject
    )
    Begin {
        [string]$Content = ""
        $Workingdir = "$env:TEMP"
        $configfile = "$Workingdir\secpol.ini"
        $configdb = "$Workingdir\temp.sdb"
        $heading = $SecurityObject | Sort-Object -Descending -Unique -Property Heading
        $Heading = $heading.heading
    }
    Process {
        Foreach ($CurrentHeading in $heading) {
            $Content += "[$($CurrentHeading.trim())]`r`n"
            $Settingarr = $SecurityObject | Where-Object -FilterScript {$_.Heading -eq $CurrentHeading}
            foreach ($currentSetting in $Settingarr) {
                $Content += "$($currentSetting.setting) = $($currentSetting.Value)`r`n"
            }
        }
    }
    End {
        #Write-Output $Content
        sleep 2
        $content | Out-File $configfile
        $return = Start-process -FilePath secedit -ArgumentList "/validate $configfile" -Wait -NoNewWindow -PassThru
        if ($return.ExitCode -ne 0) {
            throw "Unable to validate Config Error: $($return.Exitcode)"
        }
        else {
            if ( $pscmdlet.ShouldProcess("$configfile", "Update Policy with Edits") ) {
                Write-host 'check'
                $end = Start-process -FilePath secedit -ArgumentList "/configure /db $configdb /cfg $configfile" -Wait -NoNewWindow -PassThru
                if ($end.ExitCode -eq 0 -or $end.exitcode -eq 3) {
                    return
                }
                else {
                    throw "Error Saving config to system ERROR: $($end.ExitCode)"
                }
            }
        }
    }
}