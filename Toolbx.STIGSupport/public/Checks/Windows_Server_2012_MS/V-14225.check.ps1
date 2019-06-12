<#
.SYNOPSIS
    This checks for compliancy on V-14225.

    Windows 2012/2012 R2 password for the built-in Administrator account must be changed at least annually or when a member of the administrative team leaves the organization.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param($PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-14225"

# Initial Variables
$Results = @{
    VulnID   = "V-14225"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
if ( $PreCheck.hostType -ne "Domain Controller") {
    $localAdmin = ($PreCheck.secEdit -match "NewAdministratorName") -split '"' | Select-Object -Skip 1 -First 1
    Net User $localAdmin | Find /i "Password Last Set"
    [DateTime]$date = ((Net User $localAdmin | Find /i "Password Last Set") -split " " | Select-Object -Last 3) -join " "
    if ($date -gt (Get-Date).AddYears(-1)) {
        $Results.Status = "NotAFinding"
        $Results.Details = "Builtin administrator account ($localAdmin) password has been set within a year. See comments for details."
    }
    else {
        $Results.Status = "Open"
        $Results.Details = "Builtin administrator account ($localAdmin) password is over a year old! See comments for details."
    }
    $Results.Comments = Net User $localAdmin | Out-String
}
else {
    #CHECK IS WIP (verify policy exists to satisfy 'administrator leaving' clause)
    $accounts = Get-ADUser -Filter * -Properties SID, PasswordLastSet | Where SID -Like "*-500"
    if ($accounts.PasswordLastSet -gt (Get-Date).AddYears(-1)){
        #$Results.Status = "NotAFinding"
        $Results.Details = ("Builtin administrator account ("+$accounts.Name+") password has been set within a year. See comments for details.")
        $Results.Details = ($Results.Details+"`r`nPlease verify no administrator with access to this account has left since: "+$accounts.PasswordLastSet)
    }
    else {
        $Results.Status = "Open"
        $Results.Details = ("Builtin administrator account ("+$accounts.Name+") password is over a year old! See comments for details.")
    }
    $Results.Comments = $accounts | Out-String
}

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-14225 [$($Results.Status)]"

#Return results
return $Results
