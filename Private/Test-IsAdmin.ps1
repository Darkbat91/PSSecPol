Function Test-IsAdmin
{
 $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
 $principal = New-Object Security.Principal.WindowsPrincipal $identity

 return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}