[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [string]$QueryJob,

    [Parameter(Position = 1)]
    [string]$FailoverJob,

    [switch]$DryRun,
    [switch]$Help
)

# ==============================================================================
# HARDCODED JOB CONFIGURATION
# Set both values below to override $1 and $2 arguments.
# Leave empty ("") to use command line arguments instead.
# ==============================================================================

$HardcodedQueryJob    = ""
$HardcodedFailoverJob = ""

# ==============================================================================

# --- Resolve job names: hardcoded values take priority over arguments ---------

$UsingHardcoded = $false

if ($HardcodedQueryJob -and $HardcodedFailoverJob) {
    $UsingHardcoded = $true
    $QueryJob       = $HardcodedQueryJob
    $FailoverJob    = $HardcodedFailoverJob
}

# --- Help function ------------------------------------------------------------

function Show-Help {
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "  Veeam Backup Job Failover Script" -ForegroundColor Cyan
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "DESCRIPTION:" -ForegroundColor Yellow
    Write-Host "  Checks the last result of a specified Veeam backup job."
    Write-Host "  If the job has FAILED, automatically starts a designated"
    Write-Host "  failover backup job. All activity is written to a daily"
    Write-Host "  log file in E:\veeam_script_logs\"
    Write-Host ""

    Write-Host "USAGE:" -ForegroundColor Yellow
    Write-Host "  .\Veeam_BackupJob_CheckStatus_RunFallbackJob_OnFailed.ps1 <QueryJob> <FailoverJob> [options]"
    Write-Host ""
    Write-Host "ARGUMENTS:" -ForegroundColor Yellow
    Write-Host "  <QueryJob>      The name of the Veeam backup job to check."
    Write-Host "  <FailoverJob>   The name of the Veeam backup job to start"
    Write-Host "                  if <QueryJob> last result is Failed."
    Write-Host ""
    Write-Host "OPTIONS:" -ForegroundColor Yellow
    Write-Host "  -DryRun         Simulates the script without starting any"
    Write-Host "                  backup jobs. Prints each step to screen."
    Write-Host "                  Useful for testing before scheduling."
    Write-Host ""
    Write-Host "  -Verbose        Prints detailed output for every step,"
    Write-Host "                  including cmdlets being called and their"
    Write-Host "                  results. DOES start the failover job if"
    Write-Host "                  needed (combine with -DryRun to prevent)."
    Write-Host ""
    Write-Host "  -Help           Displays this help message."
    Write-Host ""
    Write-Host "HARDCODED VARIABLES:" -ForegroundColor Yellow
    Write-Host "  Job names can be hardcoded at the top of the script"
    Write-Host "  by setting the following variables:"
    Write-Host ""
    Write-Host "    `$HardcodedQueryJob    = `"PROD_SQL_Backup`"" -ForegroundColor DarkCyan
    Write-Host "    `$HardcodedFailoverJob = `"PROD_SQL_Backup_Failover`"" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "  When both are set:"
    Write-Host "    - Command line arguments are ignored"
    Write-Host "    - This help message will not display on launch"
    Write-Host "    - The log file will note that hardcoded values are in use"
    Write-Host "    - -DryRun and -Verbose will note that hardcoded values are in use"
    Write-Host "  Leave both as empty strings to use command line arguments."
    Write-Host ""
    Write-Host "LOGGING:" -ForegroundColor Yellow
    Write-Host "  Logs are written to E:\veeam_script_logs\yyyy-MM-dd.log"
    Write-Host "  If that directory does not exist, logs are written to"
    Write-Host "  the directory the script is running from."
    Write-Host "  A new log file is created each day. Each script run"
    Write-Host "  appends to the existing log for that day."
    Write-Host ""
    Write-Host "EXAMPLES:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  # Standard run - silent, starts failover job if QueryJob failed"
    Write-Host "  .\Veeam_BackupJob_CheckStatus_RunFallbackJob_OnFailed.ps1 'PROD_SQL_Backup' 'PROD_SQL_Backup_Failover'" -ForegroundColor Green
    Write-Host ""
    Write-Host "  # Dry run - shows all steps but does NOT start any jobs"
    Write-Host "  .\Veeam_BackupJob_CheckStatus_RunFallbackJob_OnFailed.ps1 'PROD_SQL_Backup' 'PROD_SQL_Backup_Failover' -DryRun" -ForegroundColor Green
    Write-Host ""
    Write-Host "  # Verbose - shows detailed output and DOES start failover job if needed"
    Write-Host "  .\Veeam_BackupJob_CheckStatus_RunFallbackJob_OnFailed.ps1 'PROD_SQL_Backup' 'PROD_SQL_Backup_Failover' -Verbose" -ForegroundColor Green
    Write-Host ""
    Write-Host "  # Dry run + Verbose - maximum detail, does NOT start any jobs"
    Write-Host "  .\Veeam_BackupJob_CheckStatus_RunFallbackJob_OnFailed.ps1 'PROD_SQL_Backup' 'PROD_SQL_Backup_Failover' -DryRun -Verbose" -ForegroundColor Green
    Write-Host ""
    Write-Host "  # Show this help message"
    Write-Host "  .\Veeam_BackupJob_CheckStatus_RunFallbackJob_OnFailed.ps1 -Help" -ForegroundColor Green
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host ""
}

# --- Show help if -Help specified or no arguments supplied (and not hardcoded) -

if (-not $UsingHardcoded) {
    if ($Help -or (-not $QueryJob -and -not $FailoverJob)) {
        Show-Help
        exit 0
    }

    if (-not $QueryJob -or -not $FailoverJob) {
        Write-Host ""
        Write-Host "Error: Both <QueryJob> and <FailoverJob> must be specified." -ForegroundColor Red
        Write-Host "Run with -Help for usage information." -ForegroundColor Yellow
        Write-Host ""
        exit 1
    }
}

# --- Helpers ------------------------------------------------------------------

$LogDir      = "E:\veeam_script_logs"
$LogFileName = (Get-Date -Format "yyyy-MM-dd") + ".log"
$LogFile     = "$LogDir\$LogFileName"

function Write-Log {
    param([string]$Message)
    Add-Content -Path $LogFile -Value $Message
    Add-Content -Path $LogFile -Value ""
}

function Write-Step {
    param([string]$Message)
    if ($DryRun) { Write-Host $Message }
}

# --- 1. Import Veeam module if not already loaded ----------------------------

Write-Step    "[1] Checking Veeam PowerShell module..."
Write-Verbose "[1] Checking Veeam PowerShell module..."

if (-not (Get-Module -Name Veeam.Backup.PowerShell)) {
    Write-Step    "    Module not loaded. Importing..."
    Write-Verbose "    Module not loaded. Importing..."
    try {
        Import-Module Veeam.Backup.PowerShell -ErrorAction Stop -WarningAction SilentlyContinue -Verbose:$false
        Write-Step    "    Module imported successfully."
        Write-Verbose "    Module imported successfully."
    }
    catch {
        $msg = "Error: Failed to import Veeam.Backup.PowerShell module. $_"
        Write-Step    $msg
        Write-Verbose $msg
        Write-Log     $msg
        exit 1
    }
} else {
    Write-Step    "    Module already loaded."
    Write-Verbose "    Module already loaded."
}

# --- 2. Create log directory and log file if needed --------------------------

Write-Step    "[2] Checking log directory and file..."
Write-Verbose "[2] Checking log directory and file..."
Write-Verbose "    Log dir  : $LogDir"
Write-Verbose "    Log file : $LogFile"

if (-not (Test-Path $LogDir)) {
    $LogDir  = $PSScriptRoot
    $LogFile = "$LogDir\$LogFileName"
    Write-Step    "    Log directory not found. Logging to script directory: $LogDir"
    Write-Verbose "    Log directory not found. Logging to script directory: $LogDir"
}

if (-not (Test-Path $LogFile)) {
    New-Item -ItemType File -Path $LogFile -Force | Out-Null
    Write-Step    "    Created log file: $LogFile"
    Write-Verbose "    Created log file: $LogFile"
}

Write-Log "=== Script run: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ==="

if ($UsingHardcoded) {
    Write-Log "Job source   : HARDCODED (command line arguments ignored)"
    Write-Step    "    NOTE: Using hardcoded job names. Command line arguments ignored."
    Write-Verbose "    NOTE: Using hardcoded job names. Command line arguments ignored."
} else {
    Write-Log "Job source   : Command line arguments"
}

Write-Log "Query job    : $QueryJob"
Write-Log "Failover job : $FailoverJob"
Write-Log "Dry run      : $DryRun"

# --- 3. Check last result of $QueryJob ---------------------------------------

Write-Step    "[3] Checking last result for: $QueryJob"
Write-Verbose "[3] Checking last result for: $QueryJob"

# Try agent/computer job first, fall back to standard job
Write-Verbose "    Running: Get-VBRComputerBackupJob -Name '$QueryJob'"
$agentJob = Get-VBRComputerBackupJob -Name $QueryJob -ErrorAction SilentlyContinue

if ($agentJob) {
    $lastResult = $agentJob.LastResult
    $jobType    = "Agent/Computer"
    Write-Verbose "    Job resolved as: Agent/Computer job"
} else {
    Write-Verbose "    Not an agent job. Running: Get-VBRJob -Name '$QueryJob'"
    try {
        $stdJob     = Get-VBRJob -Name $QueryJob -WarningAction SilentlyContinue -ErrorAction Stop
        $lastResult = $stdJob.GetLastResult()
        $jobType    = "Standard"
        Write-Verbose "    Job resolved as: Standard job"
    }
    catch {
        $msg = "Error: Could not retrieve job '$QueryJob'. $_"
        Write-Step    $msg
        Write-Verbose $msg
        Write-Log     $msg
        exit 1
    }
}

Write-Step    "    Job Type   : $jobType"
Write-Step    "    Last Result: $lastResult"
Write-Verbose "    Job Type   : $jobType"
Write-Verbose "    Last Result: $lastResult"
Write-Log     "Job type     : $jobType"
Write-Log     "Last Result for '$QueryJob': $lastResult"

# --- 4. Trigger failover job if $QueryJob failed -----------------------------

Write-Verbose "[4] Evaluating last result..."

if ($lastResult -ne "Failed") {
    $msg = "'$QueryJob' status is '$lastResult'. No failover needed."
    Write-Step    "[4] $msg"
    Write-Verbose "    $msg"
    Write-Log     $msg
    exit 0
}

$msg = "'$QueryJob' has FAILED. Failover job '$FailoverJob' will be started."
Write-Step    "[4] $msg"
Write-Verbose "    $msg"
Write-Log     "ALERT: $msg"

# --- 5. Start $FailoverJob ---------------------------------------------------

Write-Step    "[5] Starting failover job: $FailoverJob"
Write-Verbose "[5] Starting failover job: $FailoverJob"

if ($DryRun) {
    Write-Step    "    DRY RUN: Start-VBRJob -Job '$FailoverJob' was NOT called."
    Write-Verbose "    DRY RUN: Start-VBRJob -Job '$FailoverJob' was NOT called."
    Write-Log     "DRY RUN: Failover job '$FailoverJob' was NOT started (dry run mode)."
} else {
    try {
        Write-Verbose "    Calling: Start-VBRJob -Job '$FailoverJob'"
        Start-VBRJob -Job $FailoverJob -ErrorAction Stop
        Write-Log     "Failover job '$FailoverJob' started successfully."
        Write-Verbose "    Failover job '$FailoverJob' started successfully."
    }
    catch {
        $msg = "Error: Failover backup job ($FailoverJob) for failed backup job ($QueryJob) failed to run. $_"
        Write-Step    $msg
        Write-Verbose $msg
        Write-Log     $msg
        exit 1
    }
}

# --- 6. Exit -----------------------------------------------------------------

Write-Step    "[6] Script completed."
Write-Verbose "[6] Script completed."
Write-Log     "=== Script completed: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ==="

exit 0