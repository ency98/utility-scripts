#Requires -Modules Veeam.Backup.PowerShell

param (
    [string]$BackupJobName
)

# If no job name supplied, prompt — if still empty, list all jobs and exit
if (-not $BackupJobName) {
    $BackupJobName = Read-Host "Enter the Veeam backup job name (or press Enter to list all jobs)"
}

if (-not $BackupJobName) {
    Write-Host ""
    Write-Host "All Veeam Backup Jobs:" -ForegroundColor Cyan
    Write-Host ""

    $stdJobs   = Get-VBRJob -WarningAction SilentlyContinue | Select-Object Name, @{N="Type";E={"Standard"}}, @{N="LastResult";E={$_.GetLastResult()}}
    $agentJobs = Get-VBRComputerBackupJob -ErrorAction SilentlyContinue | Select-Object Name, @{N="Type";E={"Agent"}}, LastResult

    $allJobs = @($stdJobs) + @($agentJobs) | Sort-Object Name

    $allJobs | Format-Table -AutoSize -Property Name, Type, LastResult

    exit 0
}

# Try standard job first, then fall back to computer/agent backup job
$job      = Get-VBRJob -Name $BackupJobName -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
$agentJob = Get-VBRComputerBackupJob -Name $BackupJobName -ErrorAction SilentlyContinue

if (-not $job -and -not $agentJob) {
    Write-Host "Job '$BackupJobName' not found." -ForegroundColor Yellow
    exit 1
}

# Get last result — agent jobs use a different property
if ($agentJob) {
    $lastResult = $agentJob.LastResult
} else {
    $lastResult = $job.GetLastResult()
}

switch ($lastResult) {
    "Failed"  { Write-Host "$BackupJobName has FAILED" -ForegroundColor Red }
    "Warning" { Write-Host "$BackupJobName completed with WARNINGS" -ForegroundColor Yellow }
    "Success" { Write-Host "$BackupJobName completed SUCCESSFULLY" -ForegroundColor Green }
    "None"    { Write-Host "$BackupJobName has no result (job may never have run)" -ForegroundColor Gray }
    default   { Write-Host "$BackupJobName returned an unknown result: $lastResult" -ForegroundColor Gray }
}