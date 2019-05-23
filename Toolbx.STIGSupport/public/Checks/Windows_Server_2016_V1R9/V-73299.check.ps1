<#
.SYNOPSIS
    This checks for compliancy on V-73299.

    The Server Message Block (SMB) v1 protocol must be uninstalled.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param(`$PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-73299"

# Initial Variables
$Results = @{
    VulnID   = "V-73299"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$role=Get-WindowsFeature | ?{$_.Name -eq "FS-SMB1"}
if($role.Installed -eq 0){
    $Results.Status="NotAFinding"
}else{
    $Results.Status="Open"
}
$Results.Details=$role

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-73299 [$($Results.Status)]"

#Return results
return $Results
