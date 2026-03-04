@echo off

echo =============================
echo Network Configuration
echo =============================
ipconfig /all

echo.
echo =============================
echo Release DHCP
echo =============================
ipconfig /release

echo.
echo =============================
echo Renew DHCP
echo =============================
ipconfig /renew

echo.
echo =============================
echo Flush DNS
echo =============================
ipconfig /flushdns

echo.
pause