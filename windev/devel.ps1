
# Change CurrentControlSet->Services\ConDrv start=2
# C:/Program Files/PowerShell/7/pwsh.exe  -ExecutionPolicy Bypass  -NoExit -Command "& { c:/config/windev/devel.ps1 -ToolsDir c:/Tools}"

param(
    [string]$ToolsDir
)

$env:TOOLSDIR = "$ToolsDir"
import-Module -Force $ToolsDir/config/windev/windev.psd1 -DisableNameChecking
Windev-InitializePath
cd c:/src
