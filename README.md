# Windows 11 Scripts

![Platform](https://img.shields.io/badge/platform-Windows%2011-blue)  
![Language](https://img.shields.io/badge/language-Batch%20Script-green)  
![License](https://img.shields.io/badge/license-MIT-lightgrey) 
![Status](https://img.shields.io/badge/status-Active-brightgreen)  

This repository contains a collection. of Windows 11 command line and batch scripts used for troubleshooting, deployment, and system administration.

The goal of this project is to build a practical toolkit of small scripts that simplify common diagnostic tasks and make them easier to run in real environments.

These scripts are useful for:

- IT support
- Help desk troubleshooting
- Endpoint diagnostics
- Imaging and deployment workflows
- Lab environments and testing

Most scripts are written as **Windows batch files** so they can run on any Windows machine without requiring additional tools.

---
# Repository Structure

```
windows-11-scripts  
│  
├─ networking  
│ ├─ ping-test.bat  
│ ├─ tracert-route-check.bat  
│ ├─ ipconfig-diagnostics.bat  
│ ├─ network-health-check.bat  
│ └─ network-report.bat  
│  
├─ system  
│ ├─ system-info.bat  
│ ├─ disk-check.bat  
│ └─ disk-check-smart.bat
```

Scripts are grouped by purpose so they are easy to find and reuse.

***
# Networking Scripts  
  
These scripts help diagnose connectivity and network configuration issues.  
  
| Script | Description |  
|------|------|  
| ping-test.bat | Tests connectivity to common hosts |  
| tracert-route-check.bat | Displays the route packets take to reach a destination |  
| ipconfig-diagnostics.bat | Displays and resets network configuration |  
| network-health-check.bat | Runs multiple connectivity and DNS tests |  
| network-report.bat | Generates a timestamped network diagnostic report |  
  
---  
# System Scripts  
  
These scripts collect system information and disk health status.  
  
| Script | Description |  
|------|------|  
| system-info.bat | Displays system information such as OS version, CPU, and memory |  
| disk-check.bat | Runs basic disk usage and file system checks |  
| disk-check-smart.bat | Displays disk SMART health status and physical drive information |  
  
---
# Usage

Download or clone the repository.

```
git clone https://github.com/marscanbueno/windows-11-scripts.git
```

Run scripts from an **elevated command prompt** when required.

Example:

```
networking\ping-test.cmd
```

