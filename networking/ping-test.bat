@echo off
echo =============================
echo Network Ping Test
echo =============================
echo.

set TARGETS=8.8.8.8 google.com gateway

for %%A in (%TARGETS%) do (
    echo Pinging %%A ...
    ping -n 4 %%A
    echo.
)

echo Test complete.
pause
