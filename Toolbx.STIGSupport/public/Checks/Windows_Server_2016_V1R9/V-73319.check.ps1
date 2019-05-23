<#
.SYNOPSIS
    This checks for compliancy on V-73319.

    Windows Server 2016 minimum password age must be configured to at least one day.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param(`$PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-73319"

# Initial Variables
$Results = @{
    VulnID   = "V-73319"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$raw=$PreCheck.secEdit -match "MinimumPasswordAge"
[int]$value=$raw -split'= ' | select -Last 1
if($value -ge 1){
    $Results.Status="NotAFinding"
}else{
    $Results.Status="Open"
}
$Results.Details="Secedit.exe reports: $raw"

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-73319 [$($Results.Status)]"

#Return results
return $Results
