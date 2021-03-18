# PowerShell Universal Components and Examples

PowerShell Universal is the ultimate platform for building web-based IT tools. This repository contains components and examples of PowerShell Universal implementations. 

If you wish to open an issue in regards to the PowerShell Universal platform, please use the [Ironman Software Issue Tracker](https://github.com/ironmansoftware/issues).

# ⚠ Issue Migration 

We are in the process of migrating issues to a centralized repository for all [Ironman Software products](https://github.com/ironmansoftware/issues)). 

# Features

- [APIs](https://docs.ironmansoftware.com/api/about) - Build custom APIs with PowerShell
- [Automation](https://docs.ironmansoftware.com/automation/about) - Execute, audit and schedule PowerShell scripts
- [Dashboard](https://docs.ironmansoftware.com/dashboard/about) - Build webpages with PowerShell

# Resources

- [Downloads](https://ironmansoftware.com/downloads)
- [Documentation](https://docs.ironmansoftware.com/)
- [Pricing](https://store.ironmansoftware.com/pricing/powershell-universal)
- [Forums](https://forums.universaldashboard.io/)

# About this repository

This repository contains purpose built Components for the Universal Dashboard v3. 

# Component Libraries 

## Active Directory 

Universal Dashboard components for Active Directory.

```
Install-Module UniversalDashboard.ActiveDirectory
```

- New-UDADPasswordResetForm
- New-UDADRestoreDeletedUserTable

## [Azure](./Components/Azure/README.md)

Universal Dashboard Azure components. 

```
Install-Module UniversalDashboard.Azure
```

- New-UDAzureAppInsightsCounter


## [Hyper-V](./Components/Hyper-V/README.md)

Universal Dashboard Hyper-V components. 

```
Install-Module UniversalDashboard.HyperV
```

- New-UDHVVMWizard
- New-UDHVVMCard

## Monitoring

Universal Dashboard monitoring components.

```
Install-Module UniversalDashboard.Monitoring
```

- New-UDPerformanceCounterGraph

## Network

Universal Dashboard network components. 

```
Install-Module UniversalDashboard.Network
```

- New-UDPingForm

## SQL 

Universal Dashboard SQL components. Requires [dbatools](https://dbatools.io/).

```
Install-Module UniversalDashboard.SQL
```

- New-UDSQLTable
- New-UDSQLQueryTool

## [Windows](./Components/Windows/README.md)

Universal Dashboard components for Windows. 

```
Install-Module UniversalDashboard.Windows
```

- New-UDEventLogTable
- New-UDProcessTable
- New-UDServiceTable
