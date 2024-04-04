@echo off
:: Use pip to install "python-escpos"
echo Installing python-escpos...
C:/Python39/Scripts/pip.exe install python-escpos==2.2.0
C:/Python39/Scripts/pip.exe install pillow==9.5.0
C:/Python39/Scripts/pip.exe install requests
C:/Python39/Scripts/pip.exe install psutil

:: Replace printer.py with modified version
python ./escpos-modifier.py