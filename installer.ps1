function Download-VSCode {
    # Download VSCode
    Write-Host "Pulling VSCodeUserSetup"
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user" -OutFile (New-Item -Path "VSCodeUserSetup.exe" -Force)
    Write-Host "VSCodeUserSetup downloaded`n"
}

function Install-7zip {
    if (Test-Path -Path ".\7zip") {
        Write-Host ""
        Write-Host "7zip installed`n"
    } elseif (!(Test-Path -Path ".\7zip.zip")) {
        Write-Host "Pulling 7zip"
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest "https://github.com/CoriumCake/vscode-cpp-quickstart/raw/main/7-Zip.zip" -OutFile (New-Item -Path ".\7zip.zip" -Force)
        Expand-Archive -Force .\7zip.zip
        Write-Host ""
        Write-Host "7zip installed`n"

        $7zipPath = (Get-Item -Path ".\7zip\7-Zip").FullName

        $pathExists = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) -split ';' | Where-Object {$_ -eq $7zipPath}

        if (-not $pathExists) {
            $newPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) + ";$7zipPath"
            [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::User)
            Write-Host "7zip env added`n"
        } else {
            Write-Host "7zip env already exists`n"
        }

        Remove-Item ".\7zip.zip" -Force
    }
}

function Install-Mingw {
    if (Test-Path -Path ".\mingw64") {
        Write-Host "Mingw installed`n"
    } elseif (!(Test-Path -Path ".\mingw.7z")) {
        Write-Host "Downloading mingw`n"
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest "https://github.com/niXman/mingw-builds-binaries/releases/download/13.2.0-rt_v11-rev1/x86_64-13.2.0-release-mcf-seh-ucrt-rt_v11-rev1.7z" -OutFile (New-Item -Path ".\mingw.7z" -Force)
        Write-Host "Mingw downloaded`n"
    }

    if (Test-Path -Path ".\mingw.7z") {
        Write-Host ""
        Write-Host "Extracting mingw.7z`n"
        & ".\7zip\7-Zip\7z.exe" x -o"." ".\mingw.7z" -r -y
        Write-Host ""
        Write-Host "Mingw installed`n"

        $mingwPath = (Get-Item -Path ".\mingw64\bin").FullName

        $pathExists = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) -split ';' | Where-Object {$_ -eq $mingwPath}

        if (-not $pathExists) {
            $newPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) + ";$mingwPath"
            [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::User)
            Write-Host "Mingw env added`n"
        } else {
            Write-Host "Mingw env already exists`n"
        }

        Remove-Item ".\mingw.7z" -Force
    }
}

Clear-Host
Set-ExecutionPolicy Unrestricted -Scope Process

Download-VSCode
Install-7zip
Install-Mingw

Remove-Item $script:MyInvocation.MyCommand.Path -Force
