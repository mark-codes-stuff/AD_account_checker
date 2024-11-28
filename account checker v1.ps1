#This will be a basic tool for checking AD accounts for common problems

#A fancy title of course
Write-Host "Basic account checker v1"


#Import stuff
Import-Module ActiveDirectory


#Get input for the first/last names of the user
# $first = Read-Host -Prompt "Input user's first name"
# $last = Read-Host -Prompt "Input user's surname"
#for testing i'll just use my own test account for now
$first = "test"
$last = "user"

#When testing, I ran into issues where not all of the properties are exported when running -Properties *
#It will be easier to just run the cmdlet with specified properties that I want and I can always add more later
$properties = @(
    "displayName","AccountExpirationDate","Enabled","msDS-UserAccountDisabled","PasswordExpired",
    "msDS-UserPasswordExpiryTimeComputed","PasswordLastSet","lastLogonTimestamp"
    )


#Perform search for user
try {
    #ErrorAction Stop to handle missing properties - ensuring the script can at least be tested in any environment
    $user = Get-ADUser -Filter {GivenName -like $first -and Surname -like $last} -Properties $properties -ErrorAction Stop
} catch {
    Write-Warning "An error occurred: $($_.Exception.Message)"
    Exit 1 #Exit script if the search fails
}


#Some checks
Write-Host "some basic checks before anything is actually taken from AD"
Write-Host '$first' "is set to:" $first
Write-Host '$last' "is set to:" $last


#AD checks
Write-Host "Account properties from AD:"
if ($user) {
    Write-Host "User raw output (this will probably just show the OU/CN):" $user
    Write-Host "Display name is:" $user.displayName
    Write-Host "Account expiry:" $user.AccountExpirationDate
    Write-Host "Account active:" $user.Enabled
    Write-Host "Alternative account active test (may not exist):" $($user.'msDS-UserAccountDisabled')
    Write-Host "Password expired:" $($user.PasswordExpired)
    Write-Host "Password expiration date (calculated):" $($user.'msDS-UserPasswordExpiryTimeComputed')
    Write-Host "Is password change required?:" $($user.PasswordLastSet)
    $lastLogon = [DateTime]::FromFileTime($user.lastLogonTimestamp)
    Write-Host "Last recorded network logon:" $lastLogon
} else {
    Write-Warning "User not found."
}


Pause