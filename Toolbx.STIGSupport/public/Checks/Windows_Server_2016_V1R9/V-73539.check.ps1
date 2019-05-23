<#
.SYNOPSIS
    This checks for compliancy on V-73539.

    Users must be prompted to authenticate when the system wakes from sleep (plugged in).

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param(`$PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-73539"

# Initial Variables
$Results = @{
    VulnID   = "V-73539"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$key=(Get-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51\' -Name ACSettingIndex)
if(!$key){
    $Results.Details="Registry key not found!"
    $Results.Status="Open"    
}else{
    [int]$value=$key.ACSettingIndex
    if($value -eq 1){
        $Results.Details="$key"
        $Results.Status="NotAFinding"
    }else{
        $Results.Details="$key"
        $Results.Status="Open"
    }
}

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-73539 [$($Results.Status)]"

#Return results
return $Results
