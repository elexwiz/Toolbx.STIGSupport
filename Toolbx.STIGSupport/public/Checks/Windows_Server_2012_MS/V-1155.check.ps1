<#
.SYNOPSIS
    This checks for compliancy on V-1155.

    The Deny access to this computer from the network user right on member servers must be configured to prevent access from highly privileged domain accounts and local accounts on domain systems, and from unauthenticated access on all systems.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param($PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-1155"

# Initial Variables
$Results = @{
    VulnID   = "V-1155"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
$right = $PreCheck.userRights -match "SeDenyNetworkLogonRight"
if (!$right) {
    $Results.Details = "Unable to find entry in user rights!"
    $Results.Status = "Open"
}
else {
    [string]$value = $right.Accountlist
    if ($PreCheck.HostType -eq "Non-Domain" -and $value -match "Guests") {
        $Results.Details = "Verified that Guests are denied network access. See comments for details."
        $Results.Status = "NotAFinding"
    }
    else {
        if (
            ($value -match [regex]::escape($PreCheck.domain + "\Domain Admins") -or $value -match [regex]::escape($PreCheck.domain + "\Domain Server Admins")) -and
            ($value -match [regex]::escape($PreCheck.domain + "\Enterprise Admins") -or $value -match [regex]::escape($PreCheck.domain + "\Enterprise Server Admins")) -and
            $value -match "Local account" -and
            $value -match "Guests"
        ) {
            $Results.Status = "NotAFinding"
            $Results.Details = "Verified Domain Admins, Enterprise Admins, Local accounts, and Guests are denied network access. See comments for details."
        }
        else {
            $Results.Status = "Open"
            $Results.Details = "Unable to verify Domain Admins, Enterprise Admins, Local accounts, and Guests are denied network access, please review! See comments for details."
        }
    }
    $Results.Comments = ($right | Format-List | Out-String)
}

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-1155 [$($Results.Status)]"

#Return results
return $Results
