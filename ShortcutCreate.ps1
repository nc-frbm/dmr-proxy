$name = "DMR VPN proxy"

$title    = 'Shortcut create for VPN/PROXY'
$question = 'Do you want to create a shortcut for easy start of the VPN/PROXY?'
$choices  = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
if ($decision -ne 0) {
    exit
}

$name = "DMR VPN Proxy"
$inputName = Read-Host -Prompt "Do you want to name the shortcut? Default is [$name]"
if($inputName){
    $name = $inputName
}


$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\$name.lnk")
$Shortcut.IconLocation = "$pwd\vpn.ico"
$Shortcut.TargetPath = "$pwd\start.bat"
$Shortcut.Save()
