$ToolsDir = $env:TOOLSDIR

$ToolsDrive = Split-Path $ToolsDir -Qualifier

function Windev-InitializePath()
{
    $env:CARGO_HOME = "$ToolsDrive\cargo"
	
    $env:PATH += ";$ToolsDir\Git\bin;$ToolsDir\Git\usr\bin"
    $env:PATH += ";$ToolsDir\emacs\bin"
    $env:PATH += ";$ToolsDir\Code"
    $env:PATH += ";$ToolsDir\SysInternals" 
	
	$env:PATH += ";${env:CARGO_HOME}\bin"
}


function Windev-FirstTime()
{
    reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
}
