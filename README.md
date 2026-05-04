# Bash utility scripts
Various bash scripts to do various things. Most are wrappers to do routine tasks where I keep forgetting basic command syntax, or to filter and prettify output of common tasks.

Scripts are mostly slapped together with little thought, overly engineered, ham fisted, and often opnionated.

## random-64-char-hex.sh
- Generate 24 random 64 character hex strings.
<img width="430" height="372" alt="image" src="https://github.com/user-attachments/assets/e475b6a2-758c-4e9d-aa9c-2035444bd6af" />

## get-ips.sh
- Get the primary IP for each interface. Attempts to filter out lo, docker, veth, br-, virbr interfaces. Works well on basic installs.
<img width="322" height="91" alt="image" src="https://github.com/user-attachments/assets/b2e1631b-73b3-4455-99aa-e0aec35729c9" />

## get-wan-ip.sh
- Dig for the WAN IP
<img width="410" height="102" alt="image" src="https://github.com/user-attachments/assets/26cd9546-efd0-49a0-a061-7ff19129f60a" />

# PowerShell utility scripts
Various pwsh scripts to do various things.

```pwsh

========================================================
  Veeam Backup Job Failover Script
========================================================

DESCRIPTION:
  Checks the last result of a specified Veeam backup job.
  If the job has FAILED, automatically starts a designated
  failover backup job. All activity is written to a daily
  log file in E:\veeam_script_logs\

USAGE:
  .\Veeam-FailedJob-Failover.ps1 <QueryJob> <FailoverJob> [options]

ARGUMENTS:
  <QueryJob>      The name of the Veeam backup job to check.
  <FailoverJob>   The name of the Veeam backup job to start
                  if <QueryJob> last result is Failed.

OPTIONS:
  -DryRun         Simulates the script without starting any
                  backup jobs. Prints each step to screen.
                  Useful for testing before scheduling.

  -Verbose        Prints detailed output for every step,
                  including cmdlets being called and their
                  results. DOES start the failover job if
                  needed (combine with -DryRun to prevent).

  -Help           Displays this help message.

HARDCODED VARIABLES:
  Job names can be hardcoded at the top of the script
  by setting the following variables:

    $HardcodedQueryJob    = "PROD_SQL_Backup"
    $HardcodedFailoverJob = "PROD_SQL_Backup_Failover"

  When both are set:
    - Command line arguments are ignored
    - This help message will not display on launch
    - The log file will note that hardcoded values are in use
    - -DryRun and -Verbose will note that hardcoded values are in use
  Leave both as empty strings to use command line arguments.

LOGGING:
  Logs are written to E:\veeam_script_logs\yyyy-MM-dd.log
  If that directory does not exist, logs are written to
  the directory the script is running from.
  A new log file is created each day. Each script run
  appends to the existing log for that day.

EXAMPLES:

  # Standard run - silent, starts failover job if QueryJob failed
  .\Veeam-FailedJob-Failover.ps1 'PROD_SQL_Backup' 'PROD_SQL_Backup_Failover'

  # Dry run - shows all steps but does NOT start any jobs
  .\Veeam-FailedJob-Failover.ps1 'PROD_SQL_Backup' 'PROD_SQL_Backup_Failover' -DryRun

 # Verbose - shows detailed output and DOES start failover job if needed                                                                    .\Veeam-FailedJob-Failover.ps1 'PROD_SQL_Backup' 'PROD_SQL_Backup_Failover' -Verbose                                                                                                                                                                                                  # Dry run + Verbose - maximum detail, does NOT start any jobs                                                                              .\Veeam-FailedJob-Failover.ps1 'PROD_SQL_Backup' 'PROD_SQL_Backup_Failover' -DryRun -Verbose                                                                                                                                                                                          # Show this help message                                                                                                                   .\Veeam-FailedJob-Failover.ps1 -Help

========================================================
```