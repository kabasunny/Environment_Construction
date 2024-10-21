Function CreateApiDirectories {
    Write-Host "Creating directory structure for API..."

    $baseApiDir = "../api-go/src"
    $apiSubDirs = @(
        "controller",
        "service",
        "repository",
        "util",
        "dto",
        "model",
        "migrate",
        "infra",
        "middleware",
        "router"
    )

    foreach ($subDir in $apiSubDirs) {
        $dir = Join-Path $baseApiDir $subDir
        if (-not (Test-Path $dir)) {
            New-Item -Path $dir -ItemType Directory -Force
            Write-Host "Created directory: $dir"
        } else {
            Write-Host "Directory already exists: $dir"
        }
    }

    Write-Host "API directory structure creation complete."
}

# 関数を呼び出す
CreateApiDirectories
