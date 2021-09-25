# Installing Module

```powershell
Install-Module ExchangeOnlineManagement
```

# Importing Module

```powershell
Import-Module ExchangeOnlineManagement
```

# Connecting to Exchange Online

```powershell
Connect-ExchangeOnline -UserPrincipalName 'tennant_admin@ryezone.onmicrosoft.com' -ShowProgress $true
```

# Enabling Plus Addressing

https://www.vansurksum.com/2020/09/29/enabling-plus-addressing-in-office-365/

```powershell
Set-OrganizationConfig -AllowPlusAddressInRecipients $true
```