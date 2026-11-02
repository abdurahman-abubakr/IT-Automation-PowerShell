
# Windows Server / Workstation Health Report
# Read-only local system health check
# Compatible with Windows PowerShell 5.1+

param(
    [string]$OutputPath = ".\Windows-Health-Report.csv"
)

$ErrorActionPreference = "Stop"

$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

$totalMemoryGB = [math]::Round(
    $os.TotalVisibleMemorySize / 1MB, 2
)
$freeMemoryGB = [math]::Round(
    $os.FreePhysicalMemory / 1MB, 2
)

$cpuLoad = ($cpu |
    Measure-Object -Property LoadPercentage -Average).Average

$diskSummary = ($disks | ForEach-Object {
    $freePercent = if ($_.Size -gt 0) {
        [math]::Round(($_.FreeSpace / $_.Size) * 100, 1)
    } else { 0 }

    "$($_.DeviceID) $freePercent% free"
}) -join "; "

$stoppedAutoServices = @(
    Get-CimInstance Win32_Service |
    Where-Object {
        $_.StartMode -eq "Auto" -and
        $_.State -ne "Running"
    }
)

$report = [PSCustomObject]@{
    ComputerName = $env:COMPUTERNAME
    OS           = $os.Caption
    LastBoot     = $os.LastBootUpTime
    CPULoadPct   = $cpuLoad
    TotalRAMGB   = $totalMemoryGB
    FreeRAMGB    = $freeMemoryGB
    DiskStatus   = $diskSummary
    StoppedAutoServices = $stoppedAutoServices.Count
    ReportDate   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

$report | Export-Csv -Path $OutputPath `
    -NoTypeInformation -Encoding UTF8

$report | Format-List

Write-Host "Report saved to: $OutputPath"
