function main(){
    #Test if docker is installed
    if (!( Test-Command -cmdname 'docker'))
    {
         Write-Host 'You need to install docker'
         exit
    }
    
    #creating vars.config with username and password
    if (!(Test-Path ".\ResetUserNamePassword.ps1")) {
        (New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/nc-brj/dmr-proxy/master/ResetUserNamePassword.ps1", ".\ResetUserNamePassword.ps1")
    }
    #Launch passwodd resetter
    & .\ResetUserNamePassword.ps1
}
function Test-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

main