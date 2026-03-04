@echo off
title Disk Diagnostic Tool

echo ==========================================
echo           DISK DIAGNOSTICS
echo ==========================================
echo.

echo ---- Logical Disk Status ----
wmic logicaldisk get DeviceID,VolumeName,FileSystem,Size,FreeSpace
echo.

echo ---- Running CHKDSK Scan (Read Only) ----
echo This may take a moment...
echo.

chkdsk C:

echo.
echo ==========================================
echo Disk scan complete
echo ==========================================
pause