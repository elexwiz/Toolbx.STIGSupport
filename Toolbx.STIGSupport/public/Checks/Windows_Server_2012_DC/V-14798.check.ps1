<#
.SYNOPSIS
    This checks for compliancy on V-14798.

    Directory data (outside the root DSE) of a non-public directory must be configured to prevent anonymous access.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param($PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-14798"

# Initial Variables
$Results = @{
    VulnID   = "V-14798"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
#CHECK IS WIP $user = "NT AUTHORITY\ANONYMOUS LOGON"
$domain = New-Object DirectoryServices.DirectoryEntry($null,$null,$null,'Anonymous')
$adsiSearch = New-Object System.DirectoryServices.DirectorySearcher($domain)
try {
    $adsiSearch.FindAll()
}
catch {
    if (($error | Select-Object -First 1 ).Exception.Message  -like 'Exception calling "FindAll" with "0" argument(s): "An operations error occurred.*') {
        $Results.Status = "NotAFinding"
        $Results.Details = "Attempted an anonymous LDAP search and was disallowed."
    }
}
finally {
    $Results.Status = "Open"
    $Results.Details = "Anonymous LDAP search was premitted; Please review!."
}

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-14798 [$($Results.Status)]"

#Return results
return $Results
