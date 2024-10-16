# ルートディレクトリの作成
$rootPath = "./"
New-Item -ItemType Directory -Path $rootPath -Force

# api
$apiPath = "$rootPath/api"
New-Item -ItemType Directory -Path $apiPath -Force
New-Item -ItemType File -Path "$apiPath/cmd/main.go" -Force
New-Item -ItemType File -Path "$apiPath/go.mod" -Force
New-Item -ItemType File -Path "$apiPath/go.sum" -Force
New-Item -ItemType File -Path "$apiPath/Dockerfile" -Force

# api_internal
$internalPath = "$apiPath/internal"
New-Item -ItemType Directory -Path $internalPath -Force
New-Item -ItemType Directory -Path "$internalPath/repositories" -Force
New-Item -ItemType Directory -Path "$internalPath/services" -Force
New-Item -ItemType Directory -Path "$internalPath/controllers" -Force
New-Item -ItemType Directory -Path "$internalPath/dto" -Force
New-Item -ItemType Directory -Path "$internalPath/models" -Force
New-Item -ItemType Directory -Path "$internalPath/infra" -Force

# api_pkg 
New-Item -ItemType Directory -Path "$apiPath/pkg" -Force
New-Item -ItemType File -Path "$apiPath/pkg/logger.go" -Force


# data-analysis
$dataAnalysisPath = "$rootPath/data-analysis"
New-Item -ItemType Directory -Path $dataAnalysisPath -Force
New-Item -ItemType File -Path "$dataAnalysisPath/Dockerfile" -Force
New-Item -ItemType Directory -Path "$dataAnalysisPath/src" -Force
New-Item -ItemType File -Path "$dataAnalysisPath/src/app.py" -Force
New-Item -ItemType File -Path "$dataAnalysisPath/src/requirements.txt" -Force

# frontend
$frontendPath = "$rootPath/frontend"
New-Item -ItemType Directory -Path $frontendPath -Force
New-Item -ItemType File -Path "$frontendPath/Dockerfile" -Force
New-Item -ItemType File -Path "$frontendPath/package.json" -Force
New-Item -ItemType Directory -Path "$frontendPath/src" -Force

# docker-compose.yml の作成
New-Item -ItemType File -Path "$rootPath/docker-compose.yml" -Force

# .env ファイルの作成
New-Item -ItemType File -Path "$rootPath/.env" -Force

# .gitignore の作成
New-Item -ItemType File -Path "$rootPath/.gitignore" -Force

Write-Output "fin"
