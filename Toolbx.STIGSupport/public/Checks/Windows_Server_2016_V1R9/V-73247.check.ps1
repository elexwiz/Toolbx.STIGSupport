<#
.SYNOPSIS
    This checks for compliancy on V-73247.

    Local volumes must use a format that supports NTFS attributes.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param(`$PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-73247"

# Initial Variables
$Results = @{
    VulnID   = "V-73247"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$details=(Get-Volume | ?{$_.DriveType -eq 'Fixed'})
foreach($item in $details){
    #If any fixed drive is not NTFS, it is a finding
    if($item.FileSystemType -eq "NTFS" -and $Results.Status -ne "Open"){
        $Results.Status="NotAFinding"
    }else{
        $Results.Status="Open"
    }
}
$Results.Details="$details"

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-73247 [$($Results.Status)]"

#Return results
return $Results
