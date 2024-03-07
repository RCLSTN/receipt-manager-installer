@echo off
setlocal enabledelayedexpansion
:: Search "set" if you need to find any variables to change :) 

:: Set variables relevant to the receipt manager files
set "fileList="./PCoxReceiptFormat.py" "./logo.png" "./PrinterConfig.py" "./receipt-manager.pyw" "./stock.png""

cd ./receipt-manager-files

:: Retrieve Receipt Manager files if they do not already exist
for %%F in (%fileList%) do (
    if not exist "%%~F" (
        echo File not found: %%~F
        set "curlCommand=curl -O https://raw.githubusercontent.com/RCLSTN/receipt-manager/main/%%~nxF"
        echo Executing: !curlCommand!
        !curlCommand!
    ) else (
        echo File exists: %%~F
    )
)

cd ../

:: Set variables relevant to the python installer
set installerPath="./python_installer.exe"
set pythonInstallerURL="https://www.python.org/ftp/python/3.9.0/python-3.9.0-amd64.exe"

:: Retrieve a python installer if one is not already present (Any Python 3 version should work)
if not exist %installerPath% (
    echo Python installer not found. Downloading from %pythonInstallerURL%...
    echo Executing: curl -o %installerPath% %pythonInstallerURL%
    curl -o %installerPath% %pythonInstallerURL%
    
    if %errorlevel% neq 0 (
        echo Failed to download Python installer. Please check the URL or try again later.
    ) else (
        echo Python installer downloaded successfully.
    )
) else (
    echo Python installer already exists at %installerPath%.
)

echo All files checked and retrieved if needed.


:: Set the installation directory
set "installDir=C:\Python39"

:: Install Python
echo Installing Python...
python_installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 TargetDir=%installDir%

:: Add Python to PATH (if not already added)
set "pathVar=!PATH!"
if "!pathVar:Python39=!"=="%pathVar%" (
    set "pathVar=%installDir%;%pathVar%"
    setx PATH "!pathVar!" /M
)

:: Run external batch script to run python commands in same cmd that installed python
call external_installer.bat

:: Assign path variables
set "queueFolder=C:\queue"
set "pcoxPrintFolder=%queueFolder%\pcoxPrint"
set "sourceFolder=.\receipt-manager-files"
set "pythonScript=Receipt Manager - desktop.lnk"
set "desktopFolder=%USERPROFILE%\Desktop"

:: Create C:\queue if it does not exist
if not exist "%queueFolder%" (
    mkdir "%queueFolder%"
    echo Created folder: %queueFolder%
)

:: Then create C:\queue\pcoxPrint if it does not exist
if not exist "%pcoxPrintFolder%" (
    mkdir "%pcoxPrintFolder%"
    echo Created folder: %pcoxPrintFolder%
)

:: Copy contents of .\receipt-manager-files to C:\queue\pcoxPrint
xcopy /s /y "%sourceFolder%\*" "%pcoxPrintFolder%"

:: Copy C:\queue\pcoxPrint\receipt-manager.pyw to desktop
if exist "%pcoxPrintFolder%\%pythonScript%" (
    copy /y "%pcoxPrintFolder%\%pythonScript%" "%desktopFolder%"
    echo Copied %pythonScript% to desktop
    ren "%desktopFolder%\%pythonScript%" "Receipt Manager.lnk"
) else (
    echo %pythonScript% not found in %pcoxPrintFolder%
)

:: Create the Local Port for the printer to be assigned to, restart spooler for change to implement
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Ports" /v "C:\queue\job.txt" /t reg_sz

net stop spooler
net start spooler

::Assign Receipt Manager printer variables
set "PRINTER_NAME=ReceiptManager"
set "PORT_NAME=C:\queue\job.txt"
set "DRIVER_NAME=Generic / Text Only"

:: Delete the printer if it already exists
wmic printer where "Name='!PRINTER_NAME!'" delete

:: Add the local port
rundll32 printui.dll,PrintUIEntry /if /b "!PRINTER_NAME!" /f %windir%\inf\ntprint.inf /r "!PORT_NAME!" /m "!DRIVER_NAME!"

echo Printer added successfully.

echo Installation completed.
exit /b 0
