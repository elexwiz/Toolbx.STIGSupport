<#
.SYNOPSIS
    This checks for compliancy on V-73563.

    Turning off File Explorer heap termination on corruption must be disabled.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param(`$PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-73563"

# Initial Variables
$Results = @{
    VulnID   = "V-73563"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$key=(Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer\ -Name NoHeapTerminationOnCorruption)
if(!$key){
    $Results.Details="Registry key was not found."
    $Results.Status="NotAFinding"
}else{
    [int]$value=$key.NoHeapTerminationOnCorruption
    if($value -eq 0){
        $Results.Details="$key"
        $Results.Status="NotAFinding"
    }else{
        $Results.Details="$key"
        $Results.Status="Open"
    }    
}

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-73563 [$($Results.Status)]"

#Return results
return $Results
