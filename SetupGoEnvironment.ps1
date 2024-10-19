# SetupGoEnvironment.ps1
Function SetupGoEnvironment {
    Write-Host "Setting up Go environment..."
    
    Write-Host "Installing Go 1.23..."
    $goVersion = "1.23.0"
    $goInstallerUrl = "https://go.dev/dl/go$goVersion.windows-amd64.msi"
    $installerPath = "$env:TEMP\go$goVersion.windows-amd64.msi"
    
    Write-Host "Downloading Go $goVersion..."
    Invoke-WebRequest -Uri $goInstallerUrl -OutFile $installerPath
    
    Write-Host "Installing Go $goVersion..."
    Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /quiet /norestart" -NoNewWindow -Wait
    
    $goPath = "C:\Program Files\Go\bin"
    if (-not ($env:Path -contains $goPath)) {
        [Environment]::SetEnvironmentVariable("Path", $env:Path + ";" + $goPath, [EnvironmentVariableTarget]::User)
        Write-Host "Added Go to user PATH."
    }

    Write-Host "Go environment setup complete. Please restart PowerShell to apply environment variables."
}

SetupGoEnvironment
