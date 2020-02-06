#Run "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/nc-brj/dmr-proxy/master/initialize.ps1'))" to launch
function main(){
    #Test if docker is installed
    if (!( Test-Command -cmdname 'docker'))
    {
         Write-Host 'You need to install docker'
         exit
    }
    
    #Launh site for installing FoxyProxy
    Write-Host "Plase install Foxyproxy, and load config. FoxyProxy_chrome.fpx in Chrome, FoxyProxy_firefox.json in Firefox"
    Start-Process "https://www.google.com/search?q=FoxyProxy+Standard"


    Get-File-From-Github "FoxyProxy_chrome.fpx"
    Get-File-From-Github "FoxyProxy_firefox.json"
    
    Write-Host "Click enter when done"
    Pause

    Get-File-From-Github "start.bat"
    Get-File-From-Github "vpn.ico"
    Get-File-From-Github "ShortcutCreate.ps1"
    Start-Process powershell $pwd\ShortcutCreate.ps1 -Verb runAs

    #creating vars.config with username and password
    Get-File-From-Github "ResetUserNamePassword.ps1"
    #Launch password resetter
    & .\ResetUserNamePassword.ps1

    #creating start.ps1
    Get-File-From-Github "start.ps1"
    #Launch image
    & .\start.ps1
}
function Test-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}
function Get-File-From-Github($filename) {
    if (!(Test-Path ".\$filename")) {
        (New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/nc-brj/dmr-proxy/master/$filename", "$pwd\$filname")
    }    
}

main