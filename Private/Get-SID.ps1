function Get-SID
{
    #Helper to Get SID from username
    param([string]$username)
    try{
        $Account = New-Object System.Security.Principal.NTAccount($username)
        $Sid = $Account.Translate([System.Security.Principal.SecurityIdentifier]).Value
        }
    catch
        {
        Write-Warning "No User: `'$username``' found on `'$env:COMPUTERNAME`'"
        $SID = $user
        }
    return $sid
}