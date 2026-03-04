@echo off

set TARGET=%1

if "%TARGET%"=="" (
    set TARGET=google.com
)

echo =============================
echo Traceroute to %TARGET%
echo =============================
echo.

tracert %TARGET%

echo.
pause