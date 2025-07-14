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

function Windev-SetVcVars()
{
    $rootDir = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -property installationPath
    $cmdVars = "$rootDir\VC\Auxiliary\Build\vcvarsall.bat"

    $devVars = @("INCLUDE", "EXTERNAL_INCLUDE", "LIB", "LIBPATH", "PATH")
    Invoke-Command -ScriptBlock { & $env:COMSPEC /c "call `"${cmdVars}`" amd64 && set" } | Foreach-Object {
	$line = $_
	foreach ($v in $devVars) {
	    if ($line -match "^${v}=(.*)") {
		$val = $Matches[1]
		$entry = "env:${v}"
		if (Test-Path $entry) {
		    $old = (Get-Item $entry).Value
		    Set-Item "env:${v}" "$old;$val"
		} else {
		    Set-Item "env:${v}" "$val"
		}
	    }
	    
	}
    }
}
