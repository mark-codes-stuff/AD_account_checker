#This will be a basic tool for checking AD accounts for common problems

#A fancy title of course
Write-Host "Basic account checker v1"

#Import stuff
Import-Module ActiveDirectory

#Get input for the first/last names of the user
# $first = Read-Host -Prompt "Input user's first name"
# $last = Read-Host -Prompt "Input user's surname"
#for testing i'll just use my own account for now
$first = "test"
$last = "user"

#Perform search for user
$user = Get-ADUser -Filter "GivenName -like '$first' -and Surname -like '$last'" -Properties *
# need error handling here in future case account not found

#Some checks
Write-Host "some basic checks before anything is actually taken from AD"
Write-Host '$first' "is set to:" $first
Write-Host '$last' "is set to:" $last
Write-Host "Account properties from AD:"
Write-Host "user raw output (this will probably just show the OU/CN)" $user
Write-Host "Display name is:" $user.displayName
Write-Host "Account expiry:" $user.AccountExpirationDate
Write-Host "Account active:" $user.Enabled
Write-Host "Password expired:" $user.PasswordExpired
Write-Host "Password expiration date:" $user.'msDS-UserPasswordExpiryTimeComputed'
Write-Host "Is password change required?:" $user.
Write-Host "Last recorded network logon:" $user.lastLogonTimestamp
Write-Host ""
Write-Host ""
Write-Host ""


Pause