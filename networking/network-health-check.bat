@echo off
title Network Health Check

setlocal enabledelayedexpansion

echo ============================================
echo           NETWORK HEALTH CHECK
echo ============================================
echo.

:: Detect default gateway (first match)
set "GATEWAY="
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /i "Default Gateway"') do (
  for /f "tokens=1" %%G in ("%%A") do (
    if not "%%G"=="" if "!GATEWAY!"=="" set "GATEWAY=%%G"
  )
)

echo Default Gateway: %GATEWAY%
echo.

echo ---- IP Configuration Summary ----
ipconfig | findstr /i "IPv4 Default Gateway DNS"
echo.

echo ---- Ping Gateway ----
if "%GATEWAY%"=="" (
  echo Could not detect a default gateway.
) else (
  ping -n 4 %GATEWAY%
)
echo.

echo ---- Ping Internet IP (8.8.8.8) ----
ping -n 4 8.8.8.8
echo.

echo ---- DNS Resolution Tests ----
echo nslookup google.com
nslookup google.com
echo.
echo nslookup microsoft.com
nslookup microsoft.com
echo.

echo ---- Ping Hostname (DNS + ICMP) ----
ping -n 4 google.com
echo.

echo ---- Traceroute (google.com) ----
tracert google.com
echo.

echo ---- Quick HTTP Test (no browser) ----
powershell -NoProfile -Command ^
  "try { (Invoke-WebRequest -UseBasicParsing -TimeoutSec 10 'https://www.msftconnecttest.com/connecttest.txt').StatusCode } catch { $_.Exception.Message; exit 1 }"
echo.

pause
endlocal