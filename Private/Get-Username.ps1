function Get-Username {
    #Helper to Get username from SID
    param([string]$SID,
        [switch]$ShowDomain)
    try {
        $sidobj = New-Object System.Security.Principal.SecurityIdentifier($sid)
        $user = $sidobj.Translate( [System.Security.Principal.NTAccount]).Value
    }
    catch {
        Write-Verbose "No SID: `'$sid`' found on `'$env:COMPUTERNAME`'"
        $user = $SID
    }
    if ($showdomain) {
        return $user
    }
    else {
        return ($user -split '\\')[1]
    }
}