# CreateDirectoryStructure.ps1
Function CreateDirectoryStructure {
    Write-Host "Creating directory structure..."
    $directories = @(
        "api-go\src\controller",
        "api-go\src\service",
        "api-go\src\repository",
        "api-go\src\util",
        "api-go\src\dto",
        "api-go\src\model",
        "api-go\src\migrate",
        "api-go\src\infra",
        "api-go\src\middleware",
        "api-go\src\router",
        "data-analysis-python\src",
        "frontend-react"
    )
    foreach ($dir in $directories) {
        New-Item -ItemType Directory -Path $dir -Force
    }
    $files = @(
        "api-go\main.go",
        "data-analysis-python\requirements.txt",
        "data-analysis-python\src\app.py",
        "docker-compose.yml",
        ".env",
        ".gitignore"
    )
    foreach ($file in $files) {
        New-Item -ItemType File -Path $file -Force
    }
    Write-Host "Directory structure created."
}

CreateDirectoryStructure
