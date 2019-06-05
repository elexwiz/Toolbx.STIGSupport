<#
.SYNOPSIS
    This checks for compliancy on V-3245.

    Non system-created file shares on a system must limit access to groups that require it.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param($PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-3245"

# Initial Variables
$Results = @{
    VulnID   = "V-3245"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$shares = Get-SmbShare
$nonStandard=$shares | Where-Object {$_.Name -ne "ADMIN$" -and $_.Name -ne "C$" -and $_.Name -ne "IPC$"}
$rights=($shares | Get-SmbShareAccess).AccountName | Select-Object -Unique

if (!$shares) {
    $Results.Status = "Open"
    $Results.Details = "Unable to numerate shares, please investigate!"
}
elseif (!$nonStandard) {
    $Results.Status = "Not_Applicable"
    $Results.Details = "No shares except system-created are present. See comments for details."
}
elseif (($rights | Where-Object {$_ -ne "BUILTIN\Administrators" -and $_ -ne "BUILTIN\Backup Operators" -and $_ -ne "NT AUTHORITY\INTERACTIVE"}).Length -eq 0) {
    $Results.Status = "NotAFinding"
    $Results.Details = "Non-system shares exists, but rights include only Administrators, Backup Operators, and INTERACTIVE. See comments for details."
}
else {
    $Results.Status = "Open"
    $Results.Details = "Shares other than than system-created exist and their rights are not as expected! See comments for details."
}
$Results.Comments = ($shares | Format-List | Out-String) -replace "`r`n`r`n","`r`n"

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-3245 [$($Results.Status)]"

#Return results
return $Results
