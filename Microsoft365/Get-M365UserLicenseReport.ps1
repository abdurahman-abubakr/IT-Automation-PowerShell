
# Microsoft 365 User & License Report
# Requires: Microsoft.Graph.Users
# Permissions: User.Read.All, Organization.Read.All
# Output: CSV report (local only)

param(
    [string]$OutputPath = "./M365-User-License-Report.csv"
)

$ErrorActionPreference = "Stop"

Import-Module Microsoft.Graph.Users

Connect-MgGraph -Scopes @(
    "User.Read.All",
    "Organization.Read.All"
) -NoWelcome

try {
    $users = Get-MgUser -All -Property @(
        "DisplayName",
        "UserPrincipalName",
        "AccountEnabled",
        "AssignedLicenses"
    )

    $skuNames = @{}
    Get-MgSubscribedSku | ForEach-Object {
        $skuNames[$_.SkuId.ToString()] = $_.SkuPartNumber
    }

    $report = foreach ($user in $users) {
        $licenses = @(
            foreach ($license in $user.AssignedLicenses) {
                $id = $license.SkuId.ToString()
                if ($skuNames.ContainsKey($id)) {
                    $skuNames[$id]
                } else {
                    $id
                }
            }
        )

        [PSCustomObject]@{
            DisplayName       = $user.DisplayName
            UserPrincipalName = $user.UserPrincipalName
            AccountEnabled    = $user.AccountEnabled
            LicenseCount      = $licenses.Count
            Licenses          = $licenses -join "; "
        }
    }

    $report | Export-Csv -Path $OutputPath `
        -NoTypeInformation -Encoding UTF8

    Write-Host "Report saved to: $OutputPath"
}
finally {
    Disconnect-MgGraph | Out-Null
}
