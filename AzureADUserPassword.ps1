#connecting to the service
Connect-MSOLservice

#get Azure AD user by user id
Get-MSOLUser -UserPrincipalName "<user ID>" | Select-Object PasswordNeverExpires

#displaying selective user properties
Get-MSOLUser | Select-Object UserPrincipalName, PasswordNeverExpires

#set user properties
Set-MsolUser -UserPrincipalName "<user ID>" -PasswordNeverExpires \$false

#get user and then set user properties in bulk
Get-MSOLUser | Set-MsolUser -PasswordNeverExpires \$false

#setting new user password
Set-MsolUserPassword -userPrincipalName "user@consoso.com" -NewPassword "new password"