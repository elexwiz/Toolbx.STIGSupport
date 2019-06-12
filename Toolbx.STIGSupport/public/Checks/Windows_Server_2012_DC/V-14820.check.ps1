<#
.SYNOPSIS
    This checks for compliancy on V-14820.

    Domain Controller PKI certificates must be issued by the DoD PKI or an approved External Certificate Authority (ECA).

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param($PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-14820"

# Initial Variables
$Results = @{
    VulnID   = "V-14820"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$certs = (Get-ChildItem -Path Cert:Localmachine\my | Where Issuer -Like "CN=DoD *, OU=PKI, OU=DoD, O=U.S. Government, C=US")
if ($certs) {
    $Results.Status = "NotAFinding"
    $Results.Details = "Verified machine certificate is issued by DoD. See comments for details."
}
else {
    $Results.Status = "Open"
    $Results.Details = "Cannot find valid local certificate issued by DoD! See comments for details."
}
$Results.Comments = ("Local certs:`r`n"+($certs.Issuer | Select Subject, Issuer | Format-List | Out-String))

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-14820 [$($Results.Status)]"

#Return results
return $Results
