@echo off
title Disk Check (SMART)

echo ============================================
echo          DISK CHECK + SMART STATUS
echo ============================================
echo.

echo ---- Physical Drives (Model/Status) ----
wmic diskdrive get Index,Model,InterfaceType,MediaType,Size,Status
echo.

echo ---- SMART Failure Prediction ----
wmic /namespace:\\root\wmi path MSStorageDriver_FailurePredictStatus get InstanceName,PredictFailure,Reason
echo.

echo ---- Volumes (Free/Size) ----
wmic logicaldisk get DeviceID,VolumeName,FileSystem,FreeSpace,Size
echo.

echo Notes:
echo - PredictFailure=TRUE suggests the drive may fail soon.
echo - Some systems/drivers won't expose SMART through WMI.
echo.
pause