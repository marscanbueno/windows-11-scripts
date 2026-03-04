@echo off
setlocal enabledelayedexpansion
title Network Report

for /f %%T in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "TS=%%T"
set "LOG=%TEMP%\network-report_%TS%.log"

echo Writing report to: %LOG%
echo.

echo ============================================ > "%LOG%"
echo Network Report - %DATE% %TIME%>> "%LOG%"
echo Computer: %COMPUTERNAME%>> "%LOG%"
echo User: %USERNAME%>> "%LOG%"
echo Log: %LOG%>> "%LOG%"
echo ============================================>> "%LOG%"
echo.>> "%LOG%"

echo ---- IPConfig /all ---->> "%LOG%"
ipconfig /all >> "%LOG%" 2>&1
echo.>> "%LOG%"

echo ---- Route Print ---->> "%LOG%"
route print >> "%LOG%" 2>&1
echo.>> "%LOG%"

echo ---- WLAN (if applicable) ---->> "%LOG%"
netsh wlan show interfaces >> "%LOG%" 2>&1
echo.>> "%LOG%"

set "GATEWAY="
for /f %%G in ('powershell -NoProfile -Command ^
  "$gw=(Get-NetRoute -DestinationPrefix ''0.0.0.0/0'' -ErrorAction SilentlyContinue | Sort-Object RouteMetric | Select-Object -First 1 -ExpandProperty NextHop); if($gw){$gw}"') do set "GATEWAY=%%G"

echo ---- Default Gateway ---->> "%LOG%"
if not defined GATEWAY (
  echo Gateway: (not detected)>> "%LOG%"
) else (
  echo Gateway: %GATEWAY%>> "%LOG%"
)
echo.>> "%LOG%"

echo ---- Ping Gateway ---->> "%LOG%"
if defined GATEWAY (
  ping -n 4 %GATEWAY% >> "%LOG%" 2>&1
) else (
  echo Skipped (no gateway detected)>> "%LOG%"
)
echo.>> "%LOG%"

echo ---- Ping Internet IP (8.8.8.8) ---->> "%LOG%"
ping -n 4 8.8.8.8 >> "%LOG%" 2>&1
echo.>> "%LOG%"

echo ---- DNS Lookup (nslookup google.com) ---->> "%LOG%"
nslookup google.com >> "%LOG%" 2>&1
echo.>> "%LOG%"

echo ---- Traceroute (google.com) ---->> "%LOG%"
tracert google.com >> "%LOG%" 2>&1
echo.>> "%LOG%"

echo ---- HTTP Check ---->> "%LOG%"
powershell -NoProfile -Command ^
  "try { $r=Invoke-WebRequest -UseBasicParsing -TimeoutSec 10 'https://www.msftconnecttest.com/connecttest.txt'; 'HTTP Status: ' + $r.StatusCode } catch { 'HTTP Error: ' + $_.Exception.Message; exit 1 }" >> "%LOG%" 2>&1
echo.>> "%LOG%"

echo Done. Opening log...
notepad "%LOG%"
endlocal