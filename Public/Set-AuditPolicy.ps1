function Set-AuditPolicy {
    <#
.Synopsis
   Sets an Object of the Audit Policy
.DESCRIPTION
   Will Set a Value wihin the Audit Policy to the defined policy
.Example
    Set-AuditPolicy -Policy 'Credential Validation' -Setting SuccessandFailure
.NOTES
    Author: Micah
    Creation Date: 20170214
    Last Modified: 20170214
    Version: 0.0.1
    -----------------------------------------------------------------------------------------------------------------
    CHANGELOG
    -----------------------------------------------------------------------------------------------------------------
    0.0.1 Initial Release

    -----------------------------------------------------------------------------------------------------------------
    TODO
    -----------------------------------------------------------------------------------------------------------------
    1. Create Get-AuditPolicy
    2. Pre-Populate common settings
#>
    param(
        $Policy,
        [ValidateSet('Failure', 'Success', 'SuccessandFailure', 'NoAuditing')]
        $Setting)
    $Workingdir = "$env:TEMP"
    $configfile = "$Workingdir\auditpol.csv"

    #Make sure the config file doesnt exist
    Remove-Item -Path $configfile -Force -ErrorAction SilentlyContinue

    #Attempt to export
    $returncode = Start-Process -FilePath Auditpol -ArgumentList "/backup  /file:$configfile" -PassThru -NoNewWindow -Wait
    if ($returncode.ExitCode -ne 0) {
        Write-Error 'Failed to export policy'
        return
    }

    #Import our file
    $Audit = Import-Csv -Path $configfile

    #Verify the specified policy is valid
    [array]$test = $Audit | Where-Object {$_.subcategory -eq $Policy}
    if ($test.Count -ne 1) {
        Write-Error "Invalid Policy: $Policy"
        Remove-Item $configfile -Force
        return
    }

    switch ($Setting) {
        'Failure' {$SettingVal = 'Failure'; $Settingint = 2}
        'Success' {$SettingVal = 'Success'; $Settingint = 1}
        'SuccessandFailure' {
            $SettingVal = 'Success and Failure'
            $Settingint = 3
        }
        'NoAuditing' {
            $Settingval = 'No Auditing'
            $Settingint = 0
        }
        Default {throw 'Invalid Setting'}
    }

    $Audit | Where-Object {$_.subcategory -eq $Policy} | ForEach-Object {$_.'Inclusion Setting' = $SettingVal; $_.'setting value' = $Settingint}

    $Audit | Export-Csv -Path $configfile -Force -NoTypeInformation

    #region Powershell Cleanup
    $raw = Get-Content -Path $configfile
    $raw.Replace('"', '') | Out-File $configfile -Encoding utf8

    #endregion

    sleep 2
    Start-Process -FilePath Auditpol -ArgumentList "/restore /file:$configfile" -Wait -NoNewWindow
    Remove-Item -Path $configfile -Force
}