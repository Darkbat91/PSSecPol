<#
.SYNOPSIS
	Audits weak service permissions
.DESCRIPTION
	Views Services on computer and return all weak permissions that are present
.NOTES
    Author: Micah
    Creation Date: 20170329
    Last Modified: 20170329
    Version: 0.0.1
-----------------------------------------------------------------------------------------------------------------
CHANGELOG
-----------------------------------------------------------------------------------------------------------------
    0.0.1 Initial Release

-----------------------------------------------------------------------------------------------------------------
TODO
-----------------------------------------------------------------------------------------------------------------
1. Return service object with Rating for vulnerability
2. Enable remote management
3. Add option for potential option vulnerabilities that may exist
4. Pull Settings out into XML File
	#>
function Get-ServicePath
    {
    param($path)
    #[regex]$Pathregex = '(?<Path>.*\.(?<Extension>\w\w\w))\s(?<Arguments>.*)'
    [regex]$Pathregex = '(?<Path>.*\.(?<Extension>\w\w\w))(?:(?:\s(?<Arguments>.*))|(?:$))'

    $path = $path.Replace('"','')
    $path = $path.Replace("'",'')
        # Remove quotes
    if($path -match $Pathregex)
        {
        return $Matches['Path']
        }
    else
        {
        Write-Error "No Match on $path"
        }

    }



function Get-ServiceAudit
{
$IgnoreUsers = @('NT AUTHORITY\LOCAL SERVICE', 'NT Authority\System', 'BUILTIN\Administrators', 'NT SERVICE\TrustedInstaller')
$approvedRights = @('Read, Synchronize', 'ReadAndExecute, Synchronize')
$AllService = get-wmiobject -Query 'Select Name, PathName, DisplayName, StartMode from win32_service'

foreach($service in $AllService)
    {
    if($service.startmode -eq 'Auto')
        { # Only checking Auto services
        try{
            $servicepath = Get-ServicePath -path $service.PathName
          $ALLACL = Get-Acl -path  ($servicepath) -ErrorAction Stop
          }
        catch
            {
            Write-Warning "Unable to Find / Access File at $servicepath"
            }
          Foreach($acl in $ALLACL.access)
            {
            # Ignore admin and system
            if($ignoreusers -contains $acl.IdentityReference.Value)
                {
                continue
                }
            # Ignore Read / Exicute Rights
            elseif($approvedRights -contains $acl.FileSystemRights)
                {
                continue
                }
            else
                {
                Write-Output $acl
                }
            } # End ACL Foreach
        } # End service if
    } # End service foreach
}