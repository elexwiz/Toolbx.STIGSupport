<#
.SYNOPSIS
    This checks for compliancy on V-26535.

    The system must be configured to audit Account Management - Security Group Management successes.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param($PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-26535"

# Initial Variables
$Results = @{
    VulnID   = "V-26535"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$line = $PreCheck.acctMgmt -match "Security Group Management"
if ($line -like "*Success*") {
    $Results.Status = "NotAFinding"
    $Results.Details = "Account Management - Security Group Management successes are being audited. See comments for details."
}
else {
    $Results.Status = "Open"
    $Results.Details = "Account Management - Security Group Management succeses are NOT being audited. See comments for details."
}
$Results.Comments = "Auditpol.exe reports: $line"

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-26535 [$($Results.Status)]"

#Return results
return $Results
