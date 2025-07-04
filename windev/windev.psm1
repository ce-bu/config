$ToolsDir = $env:TOOLSDIR

function Windev-InitializePath()
{
    
    $env:PATH += ";$ToolsDir\Git\bin;$ToolsDir\Git\usr\bin"
    $env:PATH += ";$ToolsDir\emacs\bin"
}


function Windev-FirstTime()
{
    reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
}
