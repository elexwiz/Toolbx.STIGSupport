<#
.SYNOPSIS
    This checks for compliancy on V-39327.

    The Active Directory Infrastructure object must be configured with proper audit settings.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param($PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-39327"

# Initial Variables
$Results = @{
    VulnID   = "V-39327"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
if ($PreCheck.hostType -eq "Domain Controller") {
    Import-Module ActiveDirectory
    $path = (Get-AdDomain).distinguishedname
    $acl = Get-Acl -Audit -Path ('AD:'+$path)


    $gpos = (Get-Gpo -All)
    foreach ($gpo in $gpos) {
        $audit = (Get-Acl -Audit -Path ('AD:'+$gpo.Path)).Audit
        $fail = 0
        if ($audit.Count -eq 4) {
            foreach ($item in $audit) {
                if (
                    $item.ActiveDirectoryRights -eq "GenericAll" -and
                    $item.AuditFlags -eq "Failure" -and
                    $item.IdentityReference -eq "Everyone" -and
                    $item.IsInherited -eq "False" -and
                    $item.InheritanceType -eq "None"
                ) {
                    #Match default/expected entry
                }
                elseif (
                    $item.ActiveDirectoryRights -eq "ExtendedRight" -and
                    $item.AuditFlags -eq "Success" -and
                    $item.IdentityReference -match "\\Domain Users" -and
                    $item.IsInherited -eq "False" -and
                    $item.InheritanceType -eq "None"
                ) {
                    #Match default/expected entry
                }
                elseif (
                    $item.ActiveDirectoryRights -eq "ExtendedRight" -and
                    $item.AuditFlags -eq "Success" -and
                    $item.IdentityReference -match "\\Administrators" -and
                    $item.IsInherited -eq "False" -and
                    $item.InheritanceType -eq "None"
                ) {
                    #Match default/expected entry
                }
                elseif (
                    $item.ActiveDirectoryRights -eq "WriteProperty, WriteDacl, WriteOwner" -and
                    $item.AuditFlags -match "Success" -and
                    $item.IdentityReference -match "Everyone" -and
                    $item.IsInherited -match "False" -and
                    $item.InheritanceType -match "None"
                ) {
                    #Match default/expected entry
                }
                elseif (
                    $item.ActiveDirectoryRights -eq "WriteProperty" -and
                    $item.AuditFlags -match "Success" -and
                    $item.IdentityReference -match "Everyone" -and
                    $item.IsInherited -match "False" -and
                    $item.InheritanceType -match "All"
                ) {
                    #Match default/expected entry (two of these ones)
                }
                else{
                    $fail = 1
                }
            }
        }
        else {
            $fail = 1
        }
        if ($fail -eq 1) {
            $Results.Comments += ("`r`n-------------------------------")
            $Results.Comments += ("`r`nGPO '"+$gpo.DisplayName+"' has unexpected rights!")
            $Results.Comments += $audit | Select-Object IdentityReference,ActiveDirectoryRights,InheritanceType | Format-List | Out-String
        }
    }
    if ($Results.Comments.Length -gt 0) {
        $Results.Status = "Open"
        $Results.Details = "Found GPOs with unexpected audit rights; Please review! See comments for details."
    }
    else {
        $Results.Status = "NotAFinding"
        $Results.Details = "Found no GPOs with audit rights beyond expected values."
    }
}
else {
    $Results.Status = "Not_Applicable"
    $Results.Details = "Check only applies to Domain Controllers."
}

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-39327 [$($Results.Status)]"

#Return results
return $Results
