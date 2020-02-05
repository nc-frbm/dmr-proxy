Write-Host "Setting up username and password for SKAT VPN. Press enter to keep value written in [brackets]"

#Create file if doesnt exist
if (!(Test-Path ".\vars.config"))
{
    #Create file silently
   New-Item .\vars.config | Out-Null
}
#Load username from file with regex
$userMatchFromVars = Get-Content .\vars.config | Select-String -Pattern 'user (.*)$'

#initialize user parameter
$user

#If file has value
if($userMatchFromVars.Matches.Groups.Count -ne 0){
    $user = $userMatchFromVars.Matches.Groups[1]
    # Var for input
    $userAutoComplete = Read-Host -Prompt "Updating vars.config - Input username [$user]"
    # if enter is hit, then this is false, and input is ignored
    if($userAutoComplete){
        $user = $userAutoComplete
    }
} else {
    #If file is to be created
    $user = Read-Host -Prompt "Creating vars.config - Input username (w-number)"
}
$pass = [System.Net.NetworkCredential]::new("", (Read-Host -AsSecureString -Prompt "Enter password" )).Password

$fileContent = @"
set user $user
set pass "$pass"
"@

$fileContent | Out-File .\vars.config