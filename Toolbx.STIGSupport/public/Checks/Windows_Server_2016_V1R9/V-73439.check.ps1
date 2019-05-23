<#
.SYNOPSIS
    This checks for compliancy on V-73439.

    Windows Server 2016 must be configured to audit DS Access - Directory Service Changes successes.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param(`$PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-73439"

# Initial Variables
$Results = @{
    VulnID   = "V-73439"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$line=$dsAccess -match "Directory Service Changes"
if($line -like "*Success*"){
    $Results.Status="NotAFinding"
}else{
    $Results.Status="Open"
}
$Results.Details="Auditpol.exe reports: $line"

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-73439 [$($Results.Status)]"

#Return results
return $Results
