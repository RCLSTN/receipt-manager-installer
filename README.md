# Installer for the [RCLSTN Receipt Manager](https://github.com/RCLSTN/receipt-manager)
Scripts to mostly automate the install process for the [RCLSTN Receipt Manager](https://github.com/RCLSTN/receipt-manager)

![Windows](https://img.shields.io/badge/OS-Windows-blue.svg)
![Ver](https://img.shields.io/badge/Version-1.1-green.svg)
![Python](https://img.shields.io/badge/Python-3.9-blue.svg)

### How it works:
- Grabs all of the necessary Receipt Manager files and a python installer (3.9.0 by default)
- Installs Python 3.9.0
- Pip installs 3 required packages (psutil, requests, python-escpos)
- Automatically replaces the required modified python-escpos printer.py to allow printing to multiple receipt printers
- Creates a local port with the Generic / Text Only driver included in Windows to convert print jobs into a format that allows Receipt Manager to parse them
- Creates the necessary folders and distributes the files to the appropriate locations (including a shortcut to the desktop)

### Instructions:
1) **Put your logo as logo.png INSIDE the "receipt-manager-files" folder, otherwise it will use the default RCLSTN logo** (not good)

2) **Place your modified PrinterConfig.py file INSIDE the "receipt-manager-files" folder** (you will probably want to run this on a test machine first so you can set one up)

3) **Run "RUN_ME_AS_ADMIN.bat" as Administrator** (if this is the first time running it, it will pull all the necessary files)

4) **Once you are ready to fully deploy Receipt Manager, download [Zadig](https://zadig.akeo.ie/) and install the drivers to the receipt printers as seen [HERE](https://github.com/RCLSTN/receipt-manager/blob/main/zadig.png)**