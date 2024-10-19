# RunDockerCompose.ps1
Function RunDockerCompose {
    Write-Host "Starting Docker containers..."
    docker-compose up -d
    Write-Host "Docker containers started."
}

RunDockerCompose
