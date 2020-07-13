#Requires -RunAsAdministrator
param([String]$workDir=$pwd)

$name = "DMS VPN proxy"

$title    = 'Shortcut create for VPN/PROXY'
$question = 'Do you want to create a shortcut for easy start and stop of the VPN/PROXY?'
$choices  = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
if ($decision -ne 0) {
    exit
}

$name = "DMS VPN Proxy"

$inputName = Read-Host -Prompt "Do you want to name the shortcut? Default is [$name]"
if($inputName){
    $name = $inputName
    
}

$startName = $name + " Start"
$stopName = $name + " Stop"


$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\$startName.lnk")
$Shortcut.IconLocation = "$workDir\vpn.ico"
$Shortcut.TargetPath = "$workDir\start.bat"
$Shortcut.Save()

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\$stopName.lnk")
$Shortcut.IconLocation = "$workDir\vpn.ico"
$Shortcut.TargetPath = "$workDir\stop.bat"
$Shortcut.Save()
