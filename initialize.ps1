#Run "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/nc-brj/dmr-proxy/master/initialize.ps1'))" to launch
function main(){
    #Test if docker is installed
    if (!( Test-Command -cmdname 'docker'))
    {
         Write-Host 'You need to install Docker'
         exit
    }

    #Docker compose description
    Get-File-From-Github "docker-compose.yml"

    #FoxyProxy policy files
    Get-File-From-Github "FoxyProxy_chrome.fpx"
    Get-File-From-Github "FoxyProxy_firefox.json"
    
    $stdPort = 8888

    Port-Search-Loop $stdPort
    
    Write-Host "Please install Foxyproxy (firefox/chrome plugin), and load config through plugin. $pwd\FoxyProxy_chrome.fpx in Chrome, $pwd\FoxyProxy_firefox.json in Firefox"
    Write-Host "Click enter when done"
    Pause
    
    #Start and stop bat files and icon, for shortcuts.
    Get-File-From-Github "start.bat"
    Get-File-From-Github "start.ps1"
    Get-File-From-Github "stop.bat"
    Get-File-From-Github "vpn.ico"
    Get-File-From-Github "ShortcutCreate.ps1"

    Start-Process powershell "$pwd\ShortcutCreate.ps1 $pwd" -Verb runAs

    #variable file, for saving username and password -ADDED TO avoid UTF-8 Format bug.
    Get-File-From-Github "vars.config"

    #updating vars.config with username and password
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
        $port = Read-Host -Prompt "Port ($port) already occupied, please enter an alternate port" 
    }

    Replace-Standard-Port "FoxyProxy_chrome.fpx" $port
    Replace-Standard-Port "FoxyProxy_firefox.json" $port
    Replace-Standard-Port "docker-compose.yml" $port
}

main
