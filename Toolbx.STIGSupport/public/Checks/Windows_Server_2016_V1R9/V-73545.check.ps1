<#
.SYNOPSIS
    This checks for compliancy on V-73545.

    AutoPlay must be turned off for non-volume devices.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param(`$PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-73545"

# Initial Variables
$Results = @{
    VulnID   = "V-73545"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$key=(Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer\ -Name NoAutoplayfornonVolume)
if(!$key){
    $Results.Details="Registry key not found!"
    $Results.Status="Open"    
}else{
    [int]$value=$key.NoAutoplayfornonVolume
    if($value -eq 1){
        $Results.Details="$key"
        $Results.Status="NotAFinding"
    }else{
        $Results.Details="$key"
        $Results.Status="Open"
    }
}

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-73545 [$($Results.Status)]"

#Return results
return $Results
