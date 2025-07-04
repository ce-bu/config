
# "C:\Program Files\PowerShell\7\pwsh.exe"  -ExecutionPolicy Bypass  -NoExit -Command "& { D:\config\windev\devel.ps1 -ToolsDir d:\Tools}"

param(
    [string]$ToolsDir
)

$env:TOOLSDIR = "$ToolsDir"
import-Module -Force D:\config\windev\windev.psd1 -DisableNameChecking
Windev-InitializePath
cd d:\src
