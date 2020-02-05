#Run "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/nc-brj/dmr-proxy/master/initialize.ps1'))" to launch
function main(){
    #Test if docker is installed
    if (!( Test-Command -cmdname 'docker'))
    {
         Write-Host 'You need to install docker'
         exit
    }
    
    #creating vars.config with username and password
    if (!(Test-Path ".\ResetUserNamePassword.ps1")) {
        (New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/nc-brj/dmr-proxy/master/ResetUserNamePassword.ps1", "$pwd\ResetUserNamePassword.ps1")
    }
    #Launch password resetter
    & .\ResetUserNamePassword.ps1

    #creating start.ps1
    if (!(Test-Path ".\start.ps1")) {
        (New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/nc-brj/dmr-proxy/master/start.ps1", "$pwd\start.ps1")
    }
    #Launch image
    & .\start.ps1
}
function Test-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

main