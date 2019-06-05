<#
.SYNOPSIS
    This checks for compliancy on V-1093.

    Anonymous enumeration of shares must be restricted.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param($PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-1093"

# Initial Variables
$Results = @{
    VulnID   = "V-1093"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
[string]$keyPath = "HKLM:\System\CurrentControlSet\Control\Lsa\"
[string]$valueName = "RestrictAnonymous"
[int]$pass = 1
$key = (Get-ItemProperty $keyPath -Name $valueName)
if (!$key) {
    $Results.Details = "Registry value at $keyPath with name $valueName was not found!"
    $Results.Status = "Open"
}
else {
    [int]$value = $key.$valueName
    if ($value -eq $pass) {
        $Results.Status = "NotAFinding"
        $Results.Details = "Anonymous enumeration of shares is restricted. See comments."
    }
    else {
        $Results.Status = "Open"
        $Results.Details = "Anonymous enumeration of shares is NOT restricted! See comments."
    }
}
$Results.Comments = ("Path: "+($key.PSPath -replace [regex]::escape("Microsoft.PowerShell.Core\Registry::"),"")+"`r`nName: "+$valueName+"`r`nValue: "+($key.$valueName | foreach{ ("`r`n"+$_) }))

Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-1093 [$($Results.Status)]"

#Return results
return $Results
