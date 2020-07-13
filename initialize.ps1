#Run "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/nc-brj/dmr-proxy/master/initialize.ps1'))" to launch
function main(){
    #Test if docker is installed
    if (!( Test-Command -cmdname 'docker'))
    {
         Write-Host 'You need to install docker'
         exit
    }

    Get-File-From-Github "FoxyProxy_chrome.fpx"
    Get-File-From-Github "FoxyProxy_firefox.json"
    
    $stdPort = 8888

    if((Port-Check $stdPort) -eq $null) {

        $title    = 'Choose VNP Port'
        $question = 'Do you want to use the standard port (8888)?'
        $choices  = '&Yes', '&No'

        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
        if ($decision -ne 0) {
            $newPort = Read-Host -Prompt "Enter new port"

            Port-Search-Loop $newPort

        }
    }
    else {

        $newPort = Read-Host -Prompt "Please enter an available VPN port"

        Port-Search-Loop $newPort

        
    }
    
    Write-Host "Please install Foxyproxy (firefox/chrome plugin), and load config through plugin. $pwd\FoxyProxy_chrome.fpx in Chrome, $pwd\FoxyProxy_firefox.json in Firefox"
    Write-Host "Click enter when done"
    Pause
    
    Get-File-From-Github "start.bat"
    Get-File-From-Github "vpn.ico"
    Get-File-From-Github "ShortcutCreate.ps1"
    Get-File-From-Github "stop.bat"
    Get-File-From-Github "docker-compose.yml"

    Start-Process powershell "$pwd\ShortcutCreate.ps1 $pwd" -Verb runAs

    #creating vars.config with username and password
    Get-File-From-Github "ResetUserNamePassword.ps1"
    #Launch password resetter
    & .\ResetUserNamePassword.ps1


    #Launch image
    .\start.bat
}
function Test-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function Replace-Standard-Port($filename, $port) {
    
    (Get-Content $pwd\$filename) | ForEach-Object { $_ -replace '8888', $port } | Set-Content $pwd\$filename 
}

function Get-File-From-Github($filename) {
    if (!(Test-Path ".\$filename")) {
        (New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/nc-brj/dmr-proxy/master/$filename", "$pwd\$filename")
    }    
}

function Port-Check($port) {
    (Get-NetTCPConnection | where Localport -eq $port)
}

function Port-Search-Loop($port)
{
    while((Get-NetTCPConnection | where Localport -eq $port) -ne $null)
    {
        $port = Read-Host -Prompt "Port already occupied, please enter an alternate port" 
    }

    Replace-Standard-Port "FoxyProxy_chrome.fpx" $port
    Replace-Standard-Port "FoxyProxy_firefox.json" $port
    Replace-Standard-Port "docker-compose.yml" $port
}

main
