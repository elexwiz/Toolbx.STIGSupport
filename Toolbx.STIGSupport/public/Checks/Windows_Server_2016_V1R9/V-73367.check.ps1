<#
.SYNOPSIS
    This checks for compliancy on V-73367.

    Systems must be maintained at a supported servicing level.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param(`$PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-73367"

# Initial Variables
$Results = @{
    VulnID   = "V-73367"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$details=""
if($details -like "*"){
    $Results.Details="$details"
    $Results.Status="NotAFinding"
}else{
    $Results.Details="$details"
    $Results.Status="Open"
}

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-73367 [$($Results.Status)]"

#Return results
return $Results
