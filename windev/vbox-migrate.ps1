#Requires -Version 5.1
<#
.SYNOPSIS
    Export and Import VirtualBox VMs using VBoxManage.
.PARAMETER Action
    "Export" or "Import"
.PARAMETER VMNames
    Array of VM names to export (used with Export action)
.PARAMETER OvaPath
    Directory for exported .ova files, or path to .ova file for import
.EXAMPLE
    .\vbox-migrate.ps1 -Action Export -VMNames "MyVM1","MyVM2" -OvaPath "D:\VBoxExport"
    .\vbox-migrate.ps1 -Action Import -OvaPath "D:\VBoxExport\MyVM1.ova"
    .\vbox-migrate.ps1 -Action Import -OvaPath "D:\VBoxExport"  # imports all .ova in folder
#>
param(
    [Parameter(Mandatory)][ValidateSet("Export","Import")][string]$Action,
    [string[]]$VMNames,
    [Parameter(Mandatory)][string]$OvaPath,
    [string]$BasePath
)

# Find VBoxManage
$vboxManage = "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe"
if (-not (Test-Path $vboxManage)) {
    $vboxManage = "${env:ProgramFiles(x86)}\Oracle\VirtualBox\VBoxManage.exe"
}
if (-not (Test-Path $vboxManage)) {
    Write-Error "VBoxManage.exe not found. Is VirtualBox installed?"
    exit 1
}

function Export-VBoxVM {
    param([string]$Name, [string]$OutDir)

    # Ensure output directory exists (handles trailing backslash and missing parent dirs)
    $OutDir = $OutDir.TrimEnd('\/')
    if (-not (Test-Path $OutDir)) {
        New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
        Write-Host "  Created directory: $OutDir"
    }

    # Replace spaces in filename to avoid path issues with VBoxManage
    $safeFileName = $Name -replace ' ', '_'
    $ovaFile = Join-Path $OutDir "$safeFileName.ova"

    # Check if VM is running - power off first if needed
    $vmInfo = & $vboxManage showvminfo "$Name" --machinereadable 2>&1
    $stateMatch = $vmInfo | Select-String '^VMState="(.+)"'
    $state = if ($stateMatch) { $stateMatch.Matches[0].Groups[1].Value } else { "unknown" }

    if ($state -eq "running") {
        Write-Host "  VM '$Name' is running. Sending ACPI shutdown..."
        & $vboxManage controlvm "$Name" acpipowerbutton
        Start-Sleep -Seconds 10
        # Wait for poweroff
        for ($i = 0; $i -lt 60; $i++) {
            $vmInfo = & $vboxManage showvminfo "$Name" --machinereadable 2>&1
            $stateMatch = $vmInfo | Select-String '^VMState="(.+)"'
            $state = if ($stateMatch) { $stateMatch.Matches[0].Groups[1].Value } else { "unknown" }
            if ($state -eq "poweroff" -or $state -eq "saved" -or $state -eq "aborted") { break }
            Start-Sleep -Seconds 5
        }
    }

    Write-Host "  Exporting '$Name' -> $ovaFile ..."
    & $vboxManage export "$Name" --output "$ovaFile" --ovf20
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  SUCCESS: $ovaFile ($('{0:N0} MB' -f ((Get-Item $ovaFile).Length / 1MB)))"
    } else {
        Write-Error "  FAILED to export '$Name'"
    }
}

function Import-VBoxOva {
    param([string]$OvaFile, [string]$BasePath)

    if (-not (Test-Path $OvaFile)) {
        Write-Error "File not found: $OvaFile"
        return
    }

    Write-Host "  Importing $OvaFile ..."
    $importArgs = @($OvaFile, '--options', 'keepallmacs')
    if ($BasePath) {
        $importArgs += '--vsys', '0', '--basefolder', $BasePath
    }
    & $vboxManage import @importArgs
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  SUCCESS: Imported $(Split-Path $OvaFile -Leaf)"
    } else {
        Write-Error "  FAILED to import $OvaFile"
    }
}

# --- Main ---
switch ($Action) {
    "Export" {
        if (-not $VMNames -or $VMNames.Count -eq 0) {
            # If no names given, list available VMs and let user pick
            Write-Host "Available VMs:"
            & $vboxManage list vms
            Write-Error "Specify -VMNames parameter"
            exit 1
        }
        Write-Host "=== Exporting $($VMNames.Count) VM(s) to $OvaPath ==="
        foreach ($vm in $VMNames) {
            Export-VBoxVM -Name $vm -OutDir $OvaPath
        }
    }
    "Import" {
        if (Test-Path $OvaPath -PathType Container) {
            # Import all .ova files in directory
            $ovaFiles = Get-ChildItem -Path $OvaPath -Filter "*.ova"
            if ($ovaFiles.Count -eq 0) {
                Write-Error "No .ova files found in $OvaPath"
                exit 1
            }
            Write-Host "=== Importing $($ovaFiles.Count) VM(s) from $OvaPath ==="
            foreach ($f in $ovaFiles) {
                Import-VBoxOva -OvaFile $f.FullName -BasePath $BasePath
            }
        } else {
            Write-Host "=== Importing from $OvaPath ==="
            Import-VBoxOva -OvaFile $OvaPath -BasePath $BasePath
        }
    }
}

Write-Host "`nDone."
