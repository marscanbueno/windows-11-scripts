@echo off
title System Information Report

echo ==========================================
echo        SYSTEM INFORMATION REPORT
echo ==========================================
echo.

echo ---- Computer Name ----
hostname
echo.

echo ---- Logged In User ----
whoami
echo.

echo ---- OS Information ----
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
echo.

echo ---- System Uptime ----
systeminfo | find "System Boot Time"
echo.

echo ---- CPU ----
wmic cpu get name
echo.

echo ---- Memory ----
wmic computersystem get TotalPhysicalMemory
echo.

echo ---- Disk Drives ----
wmic logicaldisk get DeviceID,VolumeName,FileSystem,Size,FreeSpace
echo.

echo ---- Network Adapters ----
ipconfig
echo.

echo ==========================================
echo End of report
echo ==========================================
pause