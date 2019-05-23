<#
.SYNOPSIS
    This checks for compliancy on V-73321.

    Windows Server 2016 minimum password length must be configured to 14 characters.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param(`$PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-73321"

# Initial Variables
$Results = @{
    VulnID   = "V-73321"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$raw=$PreCheck.secEdit -match "MinimumPasswordLength"
[int]$value=$raw -split'= ' | select -Last 1
if($value -eq 14){
    $Results.Status="NotAFinding"
}else{
    $Results.Status="Open"
}
$Results.Details="Secedit.exe reports: $raw"

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-73321 [$($Results.Status)]"

#Return results
return $Results
