@echo off
curl -L -o installer.ps1 https://raw.githubusercontent.com/CoriumCake/vscode-cpp-quickstart/main/installer.ps1
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0installer.ps1""' -Verb RunAs}"
