@echo off
title Quick Diagnostics Tool

echo.
echo ============================================
echo        Windows Quick Diagnostics
echo ============================================
echo.

:: Create timestamp
set DATESTAMP=%DATE:~10,4%-%DATE:~4,2%-%DATE:~7,2%
set TIMESTAMP=%TIME:~0,2%-%TIME:~3,2%
set LOG=%TEMP%\quick-diagnostics-%DATESTAMP%_%TIMESTAMP%.log

echo Output log: %LOG%
echo.

echo ===== QUICK DIAGNOSTICS START ===== > "%LOG%"
echo Computer: %COMPUTERNAME% >> "%LOG%"
echo User: %USERNAME% >> "%LOG%"
echo Date: %DATE% %TIME% >> "%LOG%"
echo. >> "%LOG%"

echo Running system checks...
echo.

:: SYSTEM INFO
echo ---- SYSTEM INFO ----
echo ==== SYSTEM INFO ==== >> "%LOG%"
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" >> "%LOG%"
systeminfo | find "System Boot Time" >> "%LOG%"
echo. >> "%LOG%"

:: CPU
echo ---- CPU ----
echo ==== CPU ==== >> "%LOG%"
wmic cpu get name >> "%LOG%"
echo. >> "%LOG%"

:: MEMORY
echo ---- MEMORY ----
echo ==== MEMORY ==== >> "%LOG%"
wmic computersystem get TotalPhysicalMemory >> "%LOG%"
echo. >> "%LOG%"

:: DISK STATUS
echo ---- DISK STATUS ----
echo ==== DISK STATUS ==== >> "%LOG%"
wmic logicaldisk get DeviceID,VolumeName,FreeSpace,Size >> "%LOG%"
echo. >> "%LOG%"

:: NETWORK CONFIG
echo ---- NETWORK CONFIG ----
echo ==== IP CONFIG ==== >> "%LOG%"
ipconfig /all >> "%LOG%"
echo. >> "%LOG%"

:: DETECT DEFAULT GATEWAY
echo ---- DETECTING DEFAULT GATEWAY ----
for /f "tokens=3" %%G in ('ipconfig ^| findstr /i "Default Gateway"') do set GATEWAY=%%G

echo Gateway: %GATEWAY%
echo Gateway: %GATEWAY% >> "%LOG%"
echo.

:: PING GATEWAY
echo ---- PING GATEWAY ----
echo ==== PING GATEWAY ==== >> "%LOG%"
ping -n 4 %GATEWAY% >> "%LOG%"
echo.

:: PING INTERNET
echo ---- PING INTERNET (8.8.8.8) ----
echo ==== PING INTERNET ==== >> "%LOG%"
ping -n 4 8.8.8.8 >> "%LOG%"
echo.

:: DNS TEST
echo ---- PING GOOGLE ----
echo ==== DNS TEST ==== >> "%LOG%"
ping -n 4 google.com >> "%LOG%"
echo.

:: TRACEROUTE
echo ---- TRACEROUTE GOOGLE ----
echo ==== TRACERT ==== >> "%LOG%"
tracert google.com >> "%LOG%"
echo.

echo ===== DIAGNOSTICS COMPLETE ===== >> "%LOG%"
echo.

echo ============================================
echo Diagnostics complete
echo Log saved to:
echo %LOG%
echo ============================================

notepad "%LOG%"

pause
