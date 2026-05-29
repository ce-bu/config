<#
.SYNOPSIS
    Prevents the machine from going to standby and automatic logoff.
.DESCRIPTION
    Uses SetThreadExecutionState to prevent sleep/standby and simulates
    minor mouse movement periodically to prevent idle logoff policies.
    Press Ctrl+C to stop.
#>

param(
    [int]$IntervalSeconds = 3
)

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class PowerState {
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern uint SetThreadExecutionState(uint esFlags);

    public const uint ES_CONTINUOUS       = 0x80000000;
    public const uint ES_SYSTEM_REQUIRED  = 0x00000001;
    public const uint ES_DISPLAY_REQUIRED = 0x00000002;
}
"@

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class MouseInput {
    [DllImport("user32.dll")]
    public static extern void mouse_event(uint dwFlags, int dx, int dy, uint dwData, UIntPtr dwExtraInfo);

    public const uint MOUSEEVENTF_MOVE = 0x0001;
}
"@

# Prevent sleep/standby continuously
$flags = [PowerState]::ES_CONTINUOUS -bor [PowerState]::ES_SYSTEM_REQUIRED -bor [PowerState]::ES_DISPLAY_REQUIRED
[PowerState]::SetThreadExecutionState($flags) | Out-Null

Write-Host "Keep-Awake active. System will not sleep or lock due to inactivity." -ForegroundColor Green
Write-Host "Simulating activity every $IntervalSeconds seconds. Press Ctrl+C to stop." -ForegroundColor Yellow

try {
    while ($true) {
        # Simulate visible mouse movement to reset idle timers
        $dx = Get-Random -Minimum 5 -Maximum 15
        $dy = Get-Random -Minimum 5 -Maximum 15
        [MouseInput]::mouse_event([MouseInput]::MOUSEEVENTF_MOVE, $dx, $dy, 0, [UIntPtr]::Zero)
        Start-Sleep -Milliseconds 100
        [MouseInput]::mouse_event([MouseInput]::MOUSEEVENTF_MOVE, -$dx, -$dy, [uint]0, [UIntPtr]::Zero)

        # Re-assert execution state
        [PowerState]::SetThreadExecutionState($flags) | Out-Null

        Start-Sleep -Seconds $IntervalSeconds
    }
}
finally {
    # Restore default power state on exit
    [PowerState]::SetThreadExecutionState([PowerState]::ES_CONTINUOUS) | Out-Null
    Write-Host "`nKeep-Awake stopped. Default power settings restored." -ForegroundColor Cyan
}
