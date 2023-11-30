@echo off
curl -L -o installer.ps1 https://raw.githubusercontent.com/CoriumCake/vscode-cpp-quickstart/main/installer.ps1
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0installer.ps1"
