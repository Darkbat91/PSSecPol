function Get-SecurityPolicy {
    <#
        .Synopsis
            Returns the Vaules of specific Security Items
        .DESCRIPTION
            Will return specific secury Items or All Items within a specific heading
        .NOTES
            Author: Micah
            Creation Date: 20170208
            Last Modified: 20170208
            Version: 0.0.1
            -----------------------------------------------------------------------------------------------------------------
            CHANGELOG
            -----------------------------------------------------------------------------------------------------------------
            0.0.1 Initial Release

            -----------------------------------------------------------------------------------------------------------------
            TODO
            -----------------------------------------------------------------------------------------------------------------
            1. Improve handling of Empty Settings.
            2. Pre-Populate common settings
        #>
    [CmdletBinding()]
    [Alias('gsp')]
    Param
    (
        # Which Setting or settings are desired to be returned Can be * for all
        [Parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [string[]]$Setting = '*',
        [Parameter(Mandatory = $false,
            Position = 0)]
        [ValidateSet('Unicode', 'System Access', 'Event Audit', 'Privilege Rights')]
        $Headings = $null
    )

    Begin {
        if ((Test-IsAdmin) -eq $false) {
            Write-Warning "Cant run without admin privliges"
            return
        }
        $defaultProperties = @('Setting', 'Value')
        $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$defaultProperties)
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
        #Then $object | Add-Member MemberSet PSStandardMembers $PSStandardMembers

        $Policy = Get-SecurityObject
        $policy | Add-Member MemberSet PSStandardMembers $PSStandardMembers -Force
        if ($Headings -ne $null) {
            Write-Verbose "Filtering on Heading"
            $Policy = $Policy | Where-Object {$_.Heading -eq $Headings}
        }
    }
    Process {
        $Settingval = $Null
        $Settingval = $Policy | Where-Object -FilterScript {$_.setting -like $Setting}
        if ($Settingval -eq $null) {
            Write-Error "Security Policy `'$value`' Not Valid!"
            continue
        }
        else {
            foreach ($value in $Settingval) {
                switch ($Value.heading) {
                    'Privilege Rights' {
                        foreach ($sid in $Value) {
                            $sid.value = $sid.value -split ',' | foreach {Get-Username -SID $_.replace('*', '')}
                        }
                        Write-Output $Value
                        break
                    }
                    Default {Write-Output $value}
                }
            }

        }
    }
}