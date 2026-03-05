# Windows Printer Troubleshooting (CLI Quick Guide)

This guide lists common command line tools used to diagnose and repair printer issues on Windows endpoints.

Most printer problems fall into one of these categories:

1. Device or network connectivity
2. Windows printer configuration
3. Print spooler or driver issues

## Table of Contents

1. [Device / Network Checks](#1-device--network-checks)
    - [Check Network Connectivity](#check-network-connectivity)
    - [Open Printer Web Interface](#open-printer-web-interface)
2. Windows Printer Configuration
    - List Installed Printers
    - Check Printer Queue
    - Check Printer Ports
3. Spooler and Driver Diagnostics
    - Check Print Spooler Status
    - Restart the Print Spooler
    - Clear the Print Spool Folder
    - Open Printer Driver Management
    - Install Printer Driver Manually
4. Quick Diagnostic Workflow
5. Permission Summary
6. Common Printer Failures and Usual Causes
    - PCL XL Error Pages
    - Print Jobs Stuck in Queue
    - Printer Appears Offline
    - Incorrect or Missing Printer Drivers
    - Printer Not Found During Installation
    - Documents Print Incorrectly
    - Slow Printing
7. Printer Driver Types Explained
    - PCL
    - PostScript
    - Universal Print Drivers
8. Printer Port Types Explained
    - Standard TCP/IP Port
    - WSD
    - USB Port
9. Where to Find Printer Drivers
    - HP Drivers
    - Epson Drivers
    - Xerox Drivers
    - Ricoh Drivers
    - Microsoft Update Catalog
    - Driver Installation
10. Best Practice for Driver Selection
11. Common Printer Helpdesk Tickets and Fast Fixes
	- Printer Shows Offline
	- Print Jobs Stuck in Queue
	- PCL XL Error Pages
	- Printer Prints Random Characters
	- Printer Not Found During Installation
	- Printing Is Very Slow
	- Printer Driver Installation Fails
	- Printer Works for Some Users but Not Others
	- Printer Disappears After Reboot
	- Test Page Prints but Documents Fail
12. Quick Diagnostic Shortcut

---
# 1. Device / Network Checks

These commands verify that the printer itself is reachable.

---
## Check network connectivity

**Purpose**
Verify that the printer responds on the network.

**Applies to**
Network printers.

**Command**

```cmd
ping PRINTER_IP
```

Example

```cmd
ping 192.168.1.45
```

**Permission level**
*Standard User*
### **Interpretation**

**If Replies are received:**
→ Printer reachable on the network

**If Request timed out:** 
→ Printer offline, incorrect IP, or network issue

---

## Open printer web interface

**Purpose**
Confirm that the printer hardware is responding and accessible.

**Applies to**
Network printers with an embedded web server.

**Command**

```cmd
start http://PRINTER_IP
```

Example

```cmd
start http://192.168.1.45
```

**Permission level**
*Standard User*
### **Notes**

- Does not apply to USB printers
- If the page loads, the printer is online and reachable
- If ping works but the page does not load, the web interface may be disabled

---
# 2. Windows Printer Configuration

These commands verify how Windows is configured to use the printer.

---
## List installed printers

**Purpose**
View installed printers along with driver and port information.

**Command**

```cmd
wmic printer get name,portname,drivername
```

**Permission level**
*Standard User*
### **Notes**

Useful for identifying:

- incorrect driver (PCL vs PostScript)
- incorrect port configuration
- duplicate printers

---
## Check printer queue

**Purpose**
Identify stuck or failed print jobs.

**Command**

```cmd
wmic printjob list brief
```

**Permission level**
*Standard User*
### **Notes**

Jobs stuck in **Spooling** or **Printing** often indicate spooler problems.

---
## Check printer ports

**Purpose**
Determine how Windows connects to the printer.

**PowerShell**

```ps1
Get-PrinterPort
```

**Permission level**
*Standard User*

**Common port types**

- USB  
- WSD  
- IP_192.168.x.x
### **Notes**

Many administrators prefer **Standard TCP/IP ports** instead of WSD because they are more stable.

---
# 3. Spooler and Driver Diagnostics

These commands address the most common Windows printing failures.

---
## Check print spooler status

**Purpose**
Verify that the Windows print spooler service is running.

**Command**

```cmd
sc query spooler
```

**Permission level**
*Standard User*

**Expected output**

```cmd
STATE: RUNNING
```

If the service is stopped, printing will fail.

---
## Restart the print spooler

**Purpose**
Resolve many printing failures caused by a stalled spooler.

**Command**

```cmd
net stop spooler  
net start spooler
```

**Permission level**
*Administrator required*

---
## Clear the print spool folder

**Purpose**
Remove corrupted or stuck print jobs.

**Command**

```cmd
net stop spooler  
del /Q /F %systemroot%\System32\spool\PRINTERS\*.*  
net start spooler
```

**Permission level**
*Administrator required*

**Notes**
All pending print jobs will be removed.

---
## Open printer driver management

**Purpose**
Manage or remove problematic printer drivers.

**Command**

```cmd
printui /s /t2
```

**Permission level**
*Administrator required* to modify drivers

**Result**

Opens:

```
Print Server Properties → Drivers
```

This interface allows drivers to be removed or replaced.

---
## Install printer driver manually

**Purpose**
Install drivers from extracted driver packages.

**Command**

```cmd
pnputil /add-driver driver.inf /install
```

**Permission level**
*Administrator required*

---
# 4. Quick Diagnostic Workflow

This sequence resolves most printer issues quickly.

**Step 1**

Verify the printer is reachable.

```cmd
ping PRINTER_IP
```

**Step 2**

Confirm the printer itself is responding.

```cmd
start http://PRINTER_IP
```

**Step 3**

Verify Windows printer configuration.

```cmd
wmic printer get name,portname,drivername
```

**Step 4**

Check for stuck print jobs.

```cmd
wmic printjob list brief
```

**Step 5**

Verify spooler status.

```cmd
sc query spooler
```

**Step 6**

Restart spooler if needed.

```cmd
net stop spooler  
net start spooler
```

**Step 7**

Clear spool folder if jobs remain stuck.

**Step 8**

Verify correct printer port.

```ps1
Get-PrinterPort
```

**Step 9**

Replace problematic drivers if needed.

```cmd
printui /s /t2
```

---

# 5. Permission Summary

Commands that work without elevation

```
ping  
start http://printer_ip  
wmic printer  
wmic printjob  
sc query spooler  
Get-PrinterPort
```

Commands requiring administrator privileges

```
net stop spooler  
net start spooler  
clear spool folder  
printui /s /t2  
pnputil /add-driver
```

---
# Common Printer Failures and Usual Causes

This section lists common printing problems, their likely causes, and typical fixes.

---
## PCL XL Error Pages

**Symptoms**
Printer prints a page containing an error message such as:

```
PCL XL error  
Subsystem: TEXT  
Error: IllegalTag  
Operator: ReadFontHeader
```

**Common causes**

- Incompatible or corrupted PCL driver
- Problematic fonts or graphics in the document
- Driver mismatch between workstation and printer
- Certain PDF rendering issues

**Typical fixes**

- Install **PostScript driver instead of PCL**
- Reinstall printer using **HP Universal Print Driver – PS**
- Print the document **as an image** (for PDFs)
- Update printer firmware

---
## Print Jobs Stuck in Queue

**Symptoms**

- Jobs remain in **Spooling** or **Printing** status
- Nothing prints after sending jobs

**Common causes**

- Print spooler stalled
- Corrupted print job
- Printer offline

**Typical fixes**

Restart spooler:

```cmd
net stop spooler  
net start spooler
```

Clear spool folder if needed.

---
## Printer Appears Offline

**Symptoms**

Windows shows printer status as **Offline**.

**Common causes**

- Network connectivity issue
- Printer powered off
- Incorrect IP address
- WSD port instability

**Typical fixes**

Verify connectivity:

```
ping PRINTER_IP
```

Confirm printer port configuration.

Many admins replace **WSD ports with Standard TCP/IP ports**.

---
## Incorrect or Missing Printer Drivers

**Symptoms**

- Print jobs fail immediately
- Printer prints unreadable characters
- Windows reports driver errors

**Common causes**

- Wrong driver version
- Corrupted driver installation
- Generic driver installed by Windows

**Typical fixes**

Remove driver using:

```
printui /s /t2
```

Reinstall using correct driver package.

---
## Printer Not Found During Installation

**Symptoms**

Printer cannot be discovered during installation.

**Common causes**

- Network segmentation or VLAN restrictions
- Printer discovery disabled
- Firewall restrictions

**Typical fixes**

Install printer manually using **IP address**.

---
## Documents Print Incorrectly

**Symptoms**

- Garbled text
- Missing fonts
- Misaligned pages
- Random characters

**Common causes**

- Incorrect printer driver language (PCL vs PS)
- Application rendering issue
- Font compatibility problems

**Typical fixes**

Try a different driver type.

Common combinations:

PCL6  
PCL5  
PostScript

---
## Slow Printing

**Symptoms**

- Jobs take a long time to process before printing

**Common causes**

- Large graphics or PDFs
- Print server congestion
- Driver rendering issues

**Typical fixes**

- Print directly to printer IP instead of print server
- Use PostScript driver for complex documents
- Update firmware

---
# Quick Troubleshooting Logic

When diagnosing printer issues, follow this order:

1. Verify printer connectivity
2. Confirm printer responds
3. Check Windows printer configuration
4. Check print queue
5. Restart spooler if necessary
6. Verify printer driver
7. Replace driver if required

Most printer issues can be resolved within these steps.

---
# Printer Driver Types Explained

Printers use different **page description languages (PDL)** to interpret print jobs.  

The driver determines which language Windows sends to the printer.

The most common types are **PCL** and **PostScript**.

---
## PCL (Printer Command Language)

**Developed by**

HP

**Common variants**

- PCL5  
- PCL6  
- PCL XL

**Characteristics**

- Very common on business printers
- Fast and efficient for text documents
- Lower CPU usage on the printer
- Widely supported across vendors

**Typical usage**

- Office documents  
- Spreadsheets  
- General business printing

**Common issues**

- PCL XL errors
- Font rendering problems in PDFs
- Graphics compatibility issues

When these occur, switching to a **PostScript driver** often resolves the problem.

---
## PostScript (PS)

**Developed by**

Adobe

**Characteristics**

- Interprets complex graphics more reliably
- Handles fonts and vector graphics better
- Preferred for graphic design and publishing

**Typical usage**

- PDF files  
- Graphic design  
- Illustration software  
- Complex layouts

**Common issues**

- Slightly slower than PCL
- Larger print jobs

However, PS drivers are often **more stable with complex documents**.

---
## Universal Print Drivers

Many vendors provide **universal drivers** that support multiple models.

Examples include:

- HP Universal Print Driver
- Xerox Global Print Driver

Benefits include:

- One driver supports many printer models
- Easier deployment across environments
- Reduced driver management

---
# Printer Port Types Explained

Windows can connect to printers using several different port types.

---
## Standard TCP/IP Port

**Most common for network printers**

Example:

```
IP_192.168.1.45
```

**Advantages**

- Stable and predictable
- Direct connection to printer
- Preferred by most administrators

---
## WSD (Web Services for Devices)

Example:

```
WSD-12345678
```

**Characteristics**

- Automatic discovery
- Often installed automatically by Windows

**Common issues**

- Printer randomly shows offline
- Print failures after network changes
- Discovery instability

Because of this, many administrators **replace WSD ports with TCP/IP ports**.

---
## USB Port

Example:

```
USB001
```

**Used for**

Locally connected printers.

---
# Where to Find Printer Drivers

Manufacturers often hide drivers in multiple locations.  
The sources below are the most reliable places to locate **PCL and PostScript drivers**.

---
# HP Drivers

HP commonly provides drivers in three formats:

- PCL6  
- PCL5  
- PostScript (PS)
### Primary driver source

**HP Universal Print Driver**

Includes:

- HP Universal PCL6  
- HP Universal PCL5  
- HP Universal PostScript

These drivers support many HP LaserJet models.

---
### HP driver repository

HP maintains a public driver archive.

```
```

---
### HP Enterprise driver packs

Often labeled as:

- Driver Pack  
- IT Administrator Package  
- Corporate Driver Package

These usually contain multiple driver types.

---
# Epson Drivers

Epson printers typically provide:

- ESC/P  
- PCL  
- PostScript (optional on some models)
### Primary source

**Epson support website.

Search by model and select:

Drivers and Utilities

For enterprise models, Epson may provide **PS3 drivers**.

---
### Epson global driver

Some business Epson printers support a universal driver.

Example:

Epson Universal Print Driver

This supports multiple Epson network printers.

---
# Xerox Drivers

Xerox provides several enterprise drivers.
### Primary driver

**Xerox Global Print Driver**

Supports many Xerox devices and includes:

PCL  
PostScript

---
### Xerox driver downloads

Drivers can be found at:

https://www.support.xerox.com

Search by model.

---
### Ricoh Drivers

Ricoh printers and multifunction devices typically provide several driver types depending on the model.

Common driver types include:

- PCL6
- PostScript (PS)
- RPCS (Ricoh Printer Command Stream)

---
## Primary Source

Drivers for Ricoh printers are available on the Ricoh support website.

https://www.ricoh-usa.com/support

Search for the printer or copier model and download the appropriate driver package.

Typical navigation:

```
Support → Search by Model → Drivers & Downloads
```

---
#### Driver Types

##### PCL6 Driver

PCL6 is the most commonly used Ricoh driver for office environments.

Typical usage:

- Office documents
- Word / Excel printing
- General business printing

Advantages:

- Fast processing
- Smaller print jobs
- Good compatibility with Windows

---
##### PostScript Driver

Ricoh devices also support PostScript on many models.

Typical usage:

- PDF files
- Graphics-heavy documents
- Publishing workflows

Advantages:

- More reliable rendering of fonts and graphics
- Better compatibility with design software

---
##### RPCS Driver

RPCS stands for **Ricoh Printer Command Stream**.

This is a Ricoh-specific driver language.

Characteristics:

- Optimized for Ricoh devices
- Faster job processing
- Smaller print spool files

Typical usage:

- Standard office printing environments
- Ricoh-managed fleets

Note that RPCS drivers only work with Ricoh printers.

---
#### Ricoh Universal Print Driver

Ricoh also offers a universal driver that supports multiple Ricoh devices.

Example:

Ricoh Universal Print Driver

Benefits:

- One driver supports many Ricoh printer models
- Simplifies driver management
- Easier enterprise deployment

---
#### When to Try a Different Driver

If printing problems occur:

1. Try switching between **PCL6 and PostScript**
2. Try the **Ricoh Universal Print Driver**
3. Update printer firmware if errors persist

Switching drivers can resolve issues such as:

- formatting errors
- slow printing
- driver incompatibility

---
## Example Troubleshooting Scenario

If a Ricoh printer prints incorrectly or generates errors:

1. Remove the existing driver.
2. Install the **Ricoh Universal Print Driver**.
3. Test printing again.

Driver replacement resolves a large percentage of Ricoh printing issues.

---
# Comparing driver types across vendors

| Vendor  | PCL         | PostScript | Vendor-specific |
| ------- | ----------- | ---------- | --------------- |
| HP      | PCL5 / PCL6 | PS         | —               |
| Brother | PCL         | BR-Script  | —               |
| Ricoh   | PCL6        | PS         | RPCS            |
| Xerox   | PCL         | PS         | —               |
| Epson   | ESC/P       | PS         | —               |
___
# Microsoft Update Catalog

Sometimes printer drivers are available in the Microsoft driver catalog even when they are not listed on vendor support pages.

You can search the **Microsoft Update Catalog** for printer drivers.

Drivers are downloaded as CAB packages and installed manually.

---
# Driver Installation (Manual)

If you download extracted driver files containing an INF file, install them using:

```cmd
pnputil /add-driver driver.inf /install
```

Administrator privileges are required.

---
# Best Practice for Driver Selection

When troubleshooting printer issues:

1. Start with **vendor-recommended driver**
2. If problems occur with PCL drivers, try **PostScript**
3. Use **universal drivers** when managing multiple printer models
4. Avoid **generic Windows drivers** unless necessary

---
# Common Printer Helpdesk Tickets and Fast Fixes

This section lists common printer-related support requests and the most likely resolution steps.

These quick fixes resolve a large percentage of printer tickets.

---
## Printer Shows Offline

**Symptoms**

- Windows shows printer status as _Offline_
- Jobs remain in queue but never print

**Common causes**

- Printer powered off
- Network connectivity issue
- WSD port instability
- Incorrect IP address

**Quick checks**

Verify connectivity.

```cmd
ping PRINTER_IP
```

Open printer web interface.

```cmd
start http://PRINTER_IP
```

**Typical fix**

- Replace WSD port with **Standard TCP/IP port**
- Update printer IP if it changed

---
# Print Jobs Stuck in Queue

**Symptoms**

- Jobs stuck in _Spooling_ or _Printing_
- Nothing prints

**Common causes**

- Print spooler stalled
- Corrupted print job

**Quick fix**

Restart spooler.

```cmd
net stop spooler  
net start spooler
```

If jobs remain stuck, clear spool folder.

---
# PCL XL Error Pages

**Symptoms**

Printer prints an error page containing text similar to:

PCL XL error  
Subsystem: TEXT  
Error: IllegalTag

**Common causes**

- PCL driver incompatibility
- Font rendering issue
- PDF printing problems

**Typical fix**

Switch to a **PostScript driver**.

Example:

HP Universal Print Driver – PS

---
# Printer Prints Random Characters

**Symptoms**

- Garbled text
- Random symbols
- Unreadable pages

**Common causes**

- Wrong driver type
- Print job language mismatch

**Typical fix**

Reinstall printer using the correct driver.

Common combinations:

- PCL6  
- PCL5  
- PostScript

---
# Printer Not Found During Installation

**Symptoms**

Printer cannot be discovered during installation.

**Common causes**

- Network discovery blocked
- Printer located on another VLAN
- Printer broadcast disabled

**Typical fix**

Install printer manually using IP address.

---
# Printing Is Very Slow

**Symptoms**

Long delay before printing begins.

**Common causes**

- Large PDF files
- Complex graphics
- Print server processing delay

**Typical fixes**

- Use **PostScript driver**
- Print directly to printer IP
- Update printer firmware

---
# Printer Driver Installation Fails

**Symptoms**

- Driver fails to install
- Windows reports driver error

**Common causes**

- Corrupted driver package
- Incorrect architecture (x86 vs x64)

**Typical fix**

Remove driver and reinstall.

Open driver manager.

```
printui /s /t2
```

Remove the driver and install the correct version.

---
# Printer Works for Some Users but Not Others

**Symptoms**

- One user prints successfully
- Another user cannot print

**Common causes**

- User profile printer mapping issue
- Permissions problem
- Printer installed per-user

**Typical fix**

Remove and reinstall printer for the affected user.

---
# Printer Disappears After Reboot

**Symptoms**

Printer installed but missing after restart.

**Common causes**

- Printer installed per-user instead of system-wide
- Group Policy printer mapping conflict

**Typical fix**

Reinstall printer with administrator privileges.

---
# Test Page Prints but Documents Fail

**Symptoms**

Windows test page prints successfully but applications fail to print.

**Common causes**

- Application rendering issue
- Driver compatibility problem

**Typical fix**

Try a different driver type.

Example:

Switch from PCL6 → PostScript

---
# Quick Diagnostic Shortcut

If troubleshooting under time pressure, follow this sequence:

1. Verify printer connectivity
2. Confirm printer responds to web interface
3. Check Windows printer configuration
4. Check queue for stuck jobs
5. Restart spooler
6. Verify driver type
7. Replace driver if necessary

Most printer issues are resolved within these steps.

---