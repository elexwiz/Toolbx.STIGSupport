<#
.SYNOPSIS
    This checks for compliancy on V-15698.

    The configuration of wireless devices using Windows Connect Now must be disabled.

.PARAMETER PreCheck
    Input data as returned by the pre.check.ps1 script for this stig.
#>

[CmdletBinding()]
Param($PreCheck)

Write-Verbose "[$($MyInvocation.MyCommand)]Checking - V-15698"

# Initial Variables
$Results = @{
    VulnID   = "V-15698"
    RuleID   = ""
    Details  = ""
    Comments = ""
    Status   = "Not_Reviewed"
}

#Perform necessary check
[string]$keyPath = "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars\"
[string]$valueName = "DisableFlashConfigRegistrar"
[string]$valueName2 = "DisableInBand802DOT11Registrar"
[string]$valueName3 = "DisableUPnPRegistrar"
[string]$valueName4 = "DisableWPDRegistrar"
[string]$valueName5 = "EnableRegistrars"
[int]$pass = 0
$key = (Get-ItemProperty $keyPath -Name $valueName -ErrorAction SilentlyContinue)
$key2 = (Get-ItemProperty $keyPath -Name $valueName2 -ErrorAction SilentlyContinue)
$key3 = (Get-ItemProperty $keyPath -Name $valueName3 -ErrorAction SilentlyContinue)
$key4 = (Get-ItemProperty $keyPath -Name $valueName4 -ErrorAction SilentlyContinue)
$key5 = (Get-ItemProperty $keyPath -Name $valueName5 -ErrorAction SilentlyContinue)
if (!$key1 -or !$key2 -or !$key3 -or !$key4 -or !$key5) {
    $Results.Details = "One or more registry value was not found! See comments for details."
    $Results.Status = "Open"
}
else {
    [int]$value = $key.$valueName
    [int]$value2 = $key2.$valueName2
    [int]$value3 = $key3.$valueName3
    [int]$value4 = $key4.$valueName4
    [int]$value5 = $key5.$valueName5
    if ($value -eq $pass -and $value2 -eq $pass -and $value3 -eq $pass -and $value4 -eq $pass -and $value5 -eq $pass) {
        $Results.Status = "NotAFinding"
        $Results.Details = "All values match $pass, indicating the Responder network protocol driver is disabled. See comments for details."
    }
    else {
        $Results.Status = "Open"
        $Results.Details = "One or more value is not set to $pass! See comments for details."
    }
}
$Results.Comments = "Path: "+($key.PSPath -replace [regex]::escape("Microsoft.PowerShell.Core\Registry::"),"")
$Results.Comments = ($Results.Comments+"`r`nName: "+$valueName)
$Results.Comments = ($Results.Comments+"`r`nValue: "+($key.$valueName | foreach{ ("`r`n"+$_) }))
$Results.Comments = ($Results.Comments+"`r`nName: "+$valueName2)
$Results.Comments = ($Results.Comments+"`r`nValue: "+($key2.$valueName2 | foreach{ ("`r`n"+$_) }))
$Results.Comments = ($Results.Comments+"`r`nName: "+$valueName3)
$Results.Comments = ($Results.Comments+"`r`nValue: "+($key3.$valueName3 | foreach{ ("`r`n"+$_) }))
$Results.Comments = ($Results.Comments+"`r`nName: "+$valueName4)
$Results.Comments = ($Results.Comments+"`r`nValue: "+($key4.$valueName4 | foreach{ ("`r`n"+$_) }))
$Results.Comments = ($Results.Comments+"`r`nName: "+$valueName5)
$Results.Comments = ($Results.Comments+"`r`nValue: "+($key5.$valueName5 | foreach{ ("`r`n"+$_) }))


Write-Verbose "[$($MyInvocation.MyCommand)] Completed Checking - V-15698 [$($Results.Status)]"

#Return results
return $Results
