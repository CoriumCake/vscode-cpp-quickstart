function Install-VSCode {
    $vscodeInstallationPath = Get-Item -Path "C:\Program Files\Microsoft VS Code" -ErrorAction SilentlyContinue

    if ($null -ne $vscodeInstallationPath -and $vscodeInstallationPath.PSIsContainer) {
        if (Test-Path "VSCodeUserSetup.exe") {
            Write-Host "VSCode installer downloaded`n"
        } else {
            # Download VSCode
            Write-Host "Pulling VSCodeUserSetup.exe"
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user" -OutFile (New-Item -Path "VSCodeUserSetup.exe" -Force)
            Write-Host "VSCode installer downloaded`n"
        }
    } else {
        Write-Host "VSCode installed`n"
    }
}

function Install-7zip {
    if (Test-Path -Path .\7zip) {
        Write-Host "7zip installed"
    } elseif (!(Test-Path -Path .\7zip.zip)) {
        Write-Host "Pulling 7zip"
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest "https://github.com/CoriumCake/vscode-cpp-quickstart/raw/main/7-Zip.zip" -OutFile (New-Item -Path "7zip.zip" -Force)
        Expand-Archive -Force 7zip.zip 
        Write-Host "7zip installed`n"

        # Get the full path of the 7-Zip directory
        $7zipPath = (Get-Item -Path ".\7zip\7-Zip").FullName

        # Check if the 7-Zip directory is already in the system PATH
        $pathExists = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -split ';' | Where-Object {$_ -eq $7zipPath}

        if (-not $pathExists) {
            # Add the 7-Zip directory to the system PATH
            $newPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) + ";$7zipPath"
            [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
            Write-Host "7zip env added`n"
        } else {
            Write-Host "7zip env already exists`n"
        }
    }
}

function Install-Mingw {
    if (Test-Path -Path mingw) {
        Write-Host "Mingw installed"
    } elseif (!(Test-Path -Path mingw.7z)) {
        Write-Host "Pulling mingw`n"
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest "https://github.com/niXman/mingw-builds-binaries/releases/download/13.2.0-rt_v11-rev1/x86_64-13.2.0-release-mcf-seh-ucrt-rt_v11-rev1.7z" -OutFile (New-Item -Path "mingw.7z" -Force)

        & "$env:path\7z.exe" x -o"." "mingw.7z" -r -y

        Write-Host ""
        Write-Host "Mingw installed`n"

        # Get the full path of the Mingw directory
        $mingwPath = (Get-Item -Path ".\mingw64\bin").FullName

        $pathExists = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -split ';' | Where-Object {$_ -eq $mingwPath}

        if (-not $pathExists) {
            $newPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) + ";$mingwPath"
            [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
            Write-Host "Mingw env added`n"
        } else {
            Write-Host "Mingw env already exists`n"
        }
    }
}

Clear-Host

Install-VSCode
Install-7zip
Install-Mingw

Remove-Item $script:MyInvocation.MyCommand.Path -Force