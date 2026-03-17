$ToolsDir = $env:TOOLS_DIR
$ToolsDrive = Split-Path $ToolsDir -Qualifier

function Windev-InitializePath()
{
    $env:PATH = "${env:SystemRoot}"
    $env:PATH += ";${env:SystemRoot}\System32"
    $env:PATH += ";${env:ProgramFiles}\dotnet"
    $env:PATH += ";%SystemRoot%\System32\Wbem"
    $env:PATH += ";$ToolsDir\Powershell"
    $env:PATH += ";$ToolsDir\Git\bin"
    $env:PATH += ";$ToolsDir\Code"
    $env:PATH += ";$ToolsDir\SysInternals" 
    $env:PATH += ";$ToolsDir\Bin" 
    $env:PATH += ";${env:USERPROFILE}\.cargo\bin"
	
	$env:GTK4_ROOT = "$ToolsDir\Gtk4"
}


function Windev-FirstTime()
{
    reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
    Write-Output "Installing Powershell Azure modules (this may take a while)"
    Install-Module -Name Az -Repository PSGallery -Force
}

function Windev-SetProxy()
{
    $proxy = ([System.Net.WebRequest]::GetSystemWebproxy()).GetProxy('https://www.github.com').OriginalString
    $env:HTTPS_PROXY = $proxy
    $env:HTTP_PROXY = $proxy    
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
