
# IT Automation with PowerShell

Practical PowerShell scripts for IT administration, Microsoft 365, identity management, infrastructure monitoring, and security operations.

**Maintained by:** Abdurahman Abubakr  
**Location:** Jeddah, Saudi Arabia

## Technologies

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white)
![Microsoft 365](https://img.shields.io/badge/Microsoft_365-D83B01?style=flat-square)
![Microsoft Graph](https://img.shields.io/badge/Microsoft_Graph-0078D4?style=flat-square)
![Windows Server](https://img.shields.io/badge/Windows_Server-0078D4?style=flat-square)

## Available Scripts

| Script | Description | Status |
|---|---|---|
| [M365 User & License Report](Microsoft365/Get-M365UserLicenseReport.ps1) | Exports Microsoft 365 user accounts, account status, and assigned licenses to CSV | Added; testing pending |

## Microsoft 365 User & License Report

### Requirements

- PowerShell 7 recommended
- Microsoft Graph PowerShell modules
- Microsoft 365 tenant with appropriate read permissions
- Admin consent where required

### Install Dependencies

```powershell
Install-Module Microsoft.Graph.Users -Scope CurrentUser
Install-Module Microsoft.Graph.Identity.DirectoryManagement -Scope CurrentUser
```

### Run

```powershell
./Microsoft365/Get-M365UserLicenseReport.ps1
```

### Output

The script generates a CSV file containing:

- Display name
- User principal name
- Account enabled status
- License count
- Assigned license names

### Required Permissions

- `User.Read.All`
- `Organization.Read.All`

## Planned Improvements

- Active Directory reporting
- Endpoint security checks
- Windows Server health monitoring
- Additional Microsoft 365 administration reports

## Security

Scripts should be tested in an authorized environment before production use.

Do not commit credentials, access tokens, tenant exports, employee information, or confidential company data.

## Author

**Abdurahman Abubakr**

[LinkedIn](https://www.linkedin.com/in/abdurahman-abubakr) | [GitHub](https://github.com/abdurahman-abubakr)

## License

MIT License
