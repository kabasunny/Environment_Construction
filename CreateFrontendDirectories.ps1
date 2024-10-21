Function CreateFrontendDirectories {
    Write-Host "Creating directory structure for frontend..."

    $baseFrontendDir = "../frontend-react/vite-project/src"
    $frontendSubDirs = @(
        "components",
        "pages",
        "hooks",
        "services",
        "utils",
        "types",
        "context"
    )

    foreach ($subDir in $frontendSubDirs) {
        $dir = Join-Path $baseFrontendDir $subDir
        if (-not (Test-Path $dir)) {
            New-Item -Path $dir -ItemType Directory -Force
            Write-Host "Created directory: $dir"
        } else {
            Write-Host "Directory already exists: $dir"
        }
    }

    Write-Host "Frontend directory structure creation complete."
}

# 関数を呼び出す
CreateFrontendDirectories
