# RunDockerCompose.ps1
Function RunDockerCompose {
    Write-Host "Starting Docker containers..."
    Set-Location ..
    docker-compose up -d
    Write-Host "Docker containers started."
}

RunDockerCompose
