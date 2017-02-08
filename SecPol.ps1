#$Policy.'LockoutBadCount ' = 3
Set-Securitypolicy -Setting 'LockoutBadCount' -Value 3 -Confirm:$false
    #V-1097

#$Policy.'ForceLogoffWhenHourExpire ' = 1
Set-Securitypolicy -Setting 'ForceLogoffWhenHourExpire' -Value 1 -Confirm:$false
    #V-3380

#$Policy.'LockoutDuration ' = 0
Set-Securitypolicy -Setting 'LockoutDuration' -Value -1 -Confirm:$false
    #V-1098

#$Policy.'ResetLockoutCount ' = 60
Set-Securitypolicy -Setting 'ResetLockoutCount' -Value 60 -Confirm:$false
    #V-1099

#$Policy.'MinimumPasswordAge ' = 1
Set-Securitypolicy -Setting 'MinimumPasswordAge' -Value 1 -Confirm:$false
    #V-1105

#$Policy.'PasswordHistorySize ' = 24
Set-Securitypolicy -Setting 'PasswordHistorySize' -Value 24 -Confirm:$false
    #V-1107

#$Policy.'NewAdministratorName ' = 'MOGADMINDisabled'
Set-Securitypolicy -Setting 'NewAdministratorName' -Value 'WSADMIN' -Confirm:$false
    #V-1115

#$policy.'NewGuestName ' = 'MOGguestAccountDisabled'
Set-Securitypolicy -Setting 'NewGuestName' -Value 'guestAccountDisabled' -Confirm:$false
    #V-1114
#$Policy.'PasswordComplexity ' = 1
Set-Securitypolicy -Setting 'PasswordComplexity' -Value 1 -Confirm:$false
    #V-1150

#$Policy.'SeDenyNetworkLogonRight ' += '*S-1-5-32-546'
Set-Securitypolicy -Setting 'SeDenyNetworkLogonRight' -Value ',*S-1-5-32-546' -Add -Confirm:$false
    #V-1155 - Add Guests group to deny network logon rights

#$Policy.'MinimumPasswordLength ' = 14
Set-Securitypolicy -Setting 'MinimumPasswordLength' -Value 14 -Confirm:$false
    #V-6836

#$Policy.SeNetworkLogonRight = '*S-1-5-32-544'
Set-Securitypolicy -Setting 'SeNetworkLogonRight' -Value '' -Confirm:$false
    #V-26470 - Only Administrators

#$Policy.SeInteractiveLogonRight = '*S-1-5-32-544, *S-1-5-32-545'
Set-Securitypolicy -Setting 'SeInteractiveLogonRight' -Value '*S-1-5-32-544' -Confirm:$false
Set-Securitypolicy -Setting 'SeInteractiveLogonRight' -Value ',*S-1-5-32-545' -Add -Confirm:$false
    #V-26472 - Only Users and Administrators

#$Policy.SeRemoteInteractiveLogonRight = ''
Set-Securitypolicy -Setting 'SeRemoteInteractiveLogonRight' -Value '' -Confirm:$false
    #V-26473 - None

#$Policy.SeBackupPrivilege = '*S-1-5-32-544'
Set-Securitypolicy -Setting 'SeBackupPrivilege' -Value '*S-1-5-32-544' -Confirm:$false
    #V-26474 - Only admins can backup

#$Policy.SeDenyBatchLogonRight = '*S-1-1-0,*S-1-5-32-546'
Set-Securitypolicy -Heading "Privilege Rights" -Setting 'SeDenyBatchLogonRight' -Value '*S-1-1-0' -AddSetting -Confirm:$false
Set-Securitypolicy -Setting 'SeDenyBatchLogonRight' -Value ',*S-1-5-32-546' -Add -Confirm:$false # For some reason this , is needed
    #V-26483 - Add Guests and Everyone to the Denybatch logon right group

#$Policy.SeDenyInteractiveLogonRight = '*S-1-5-32-546'
Set-Securitypolicy -Heading "Privilege Rights" -Setting 'SeDenyInteractiveLogonRight' -Value '*S-1-5-32-546' -AddSetting -Confirm:$false
    #V-26485 - Add Guests group to deny interactive logon

#$Policy.SeDenyRemoteInteractiveLogonRight = '*S-1-1-0,*S-1-5-32-546'
Set-Securitypolicy -Heading "Privilege Rights" -Setting 'SeDenyRemoteInteractiveLogonRight' -Value '*S-1-1-0' -AddSetting -Confirm:$false
Set-Securitypolicy -Setting 'SeDenyRemoteInteractiveLogonRight' -Value ',*S-1-5-32-546' -Add -Confirm:$false
    #V-26486 - Add Guests and Everyone to Deny Remote login right

#$Policy.SeIncreaseWorkingSetPrivilege = '*S-1-5-19,*S-1-5-32-544'
Set-Securitypolicy -Heading "Privilege Rights" -Setting 'SeIncreaseWorkingSetPrivilege' -Value '*S-1-5-19' -AddSetting -Confirm:$false
Set-Securitypolicy -Setting 'SeIncreaseWorkingSetPrivilege' -Value ',*S-1-5-32-544' -Add -Confirm:$false
    #V-26491 - Add Administrators and local service increase working set

#$Policy.SeBatchLogonRight = ''
Set-Securitypolicy -Setting 'SeBatchLogonRight' -Value '' -Confirm:$false
    #V-26495 - Set Logon as a batch job to no one

#$Policy.SeRestorePrivilege = '*S-1-5-32-544'
Set-Securitypolicy -Setting 'SeRestorePrivilege' -Value '*S-1-5-32-544' -Confirm:$false
    #V-26504 - Only admins can Restore

#$Policy.SeShutdownPrivilege = '*S-1-5-32-544, *S-1-5-32-545'
Set-Securitypolicy -Setting 'SeShutdownPrivilege' -Value '*S-1-5-32-544' -Confirm:$false
Set-Securitypolicy -Setting 'SeShutdownPrivilege' -Value ',*S-1-5-32-545' -Add -Confirm:$false
    #V-26505 - Only users and admins can shutdown system

#$Policy.SeServiceLogonRight = ''
Set-Securitypolicy -Setting 'SeServiceLogonRight' -Value '' -Confirm:$false
    #V-28285 - No one can log in as a service

Set-Securitypolicy -Heading "Privilege Rights" -Setting 'SedebugPrivilege' -Value '' -AddSetting -Confirm:$false
    #V-25018

Set-Securitypolicy -Heading "Privilege Rights" -Setting 'seChangeNotifyPrivilege' -Value '' -AddSetting -Confirm:$false
