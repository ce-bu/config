# Assume the config is checked out under c:\Tools\Config
# Windows shortcut
# C:\Windows\System32\cmd.exe /k C:\Tools\Powershell\pwsh.exe -ExecutionPolicy Bypass -NoExit -Command " & { C:\Tools\Config\windev\devel.ps1 -ToolsDir C:\Tools } "

# Terminal command 
# C:\Tools\Powershell\pwsh.exe -ExecutionPolicy Bypass -NoExit -Command " & { C:\Tools\Config\windev\devel.ps1 -ToolsDir C:\Tools } "

param(
    [string]$ToolsDir
)

$thisDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$env:TOOLS_DIR = "$ToolsDir"

import-Module -Force $thisDir\windev.psd1 -DisableNameChecking
Windev-InitializePath
