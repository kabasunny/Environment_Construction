# ZenInvestor Setup Script
# ファイルの実行前に Set-ExecutionPolicy RemoteSigned を実行してください

# 必要なディレクトリ構造を作成
Write-Host "Creating directory structure..."
New-Item -ItemType Directory -Path api-go\src\controller -Force
New-Item -ItemType Directory -Path api-go\src\service -Force
New-Item -ItemType Directory -Path api-go\src\repository -Force
New-Item -ItemType Directory -Path api-go\src\util -Force
New-Item -ItemType Directory -Path api-go\src\dto -Force
New-Item -ItemType Directory -Path api-go\src\mode -Force
New-Item -ItemType Directory -Path api-go\src\migrate -Force
New-Item -ItemType Directory -Path api-go\src\infra -Force
New-Item -ItemType Directory -Path api-go\src\middleware -Force
New-Item -ItemType Directory -Path api-go\src\router -Force
New-Item -ItemType File -Path api-go\main.go -Force

New-Item -ItemType Directory -Path data-analysis-python\src -Force
New-Item -ItemType File -Path data-analysis-python\requirements.txt -Force
New-Item -ItemType File -Path data-analysis-python\src\app.py -Force

New-Item -ItemType Directory -Path frontend-react -Force

New-Item -ItemType File -Path docker-compose.yml -Force
New-Item -ItemType File -Path .env -Force
New-Item -ItemType File -Path .gitignore -Force

Write-Host "Directory structure created."

# api-goのセットアップ
Write-Host "Setting up Go project..."
Set-Location api-go

# Go 1.23のインストール（MacやLinuxはそれぞれのパッケージ管理システムでインストール）
Write-Host "Installing Go 1.23..."
# Windows用のGoのインストールはPowerShellでは難しいので、手動でダウンロードを促します。
Write-Host "Please download and install Go 1.23 from https://golang.org/dl/"

# Ginフレームワークをインストール
Write-Host "Installing Gin framework..."
go mod init zeninvestor
go get github.com/gin-gonic/gin

# main.goのサンプルコードを記載
Set-Content main.go @'
package main

import (
    "github.com/gin-gonic/gin"
)

func main() {
    router := gin.Default()
    router.GET("/ping", func(c *gin.Context) {
        c.JSON(200, gin.H{
            "message": "pong",
        })
    })
    router.Run(":8080")
}
'@

Write-Host "api-go setup complete."

# data-analysis-pythonのセットアップ
Write-Host "Setting up Python project..."
Set-Location ..\data-analysis-python

# Python3.11のインストール（手動でインストール）
Write-Host "Please install Python 3.11 from https://www.python.org/downloads/"

# 仮想環境の作成
Write-Host "Creating Python virtual environment..."
python -m venv venv

# 仮想環境の有効化
Write-Host "Activating Python virtual environment..."
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
.\venv\Scripts\Activate

# 必要なライブラリをrequirements.txtに記載
Write-Host "Writing requirements.txt..."
Set-Content requirements.txt @'
Flask
pandas
matplotlib
seaborn
waitress
numpy
lightgbm
yfinance
'@

# app.pyのサンプルコードを記載
Write-Host "Writing app.py..."
Set-Content src\app.py @'
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5006)
'@

Write-Host "data-analysis-python setup complete."

# frontend-reactのセットアップ
Write-Host "Setting up React project..."
Set-Location ..\frontend-react

# React + TypeScriptプロジェクトの作成
Write-Host "Creating React project with TypeScript..."
npx create-react-app . --template typescript

# Reactのポートを環境変数で指定されたポートに設定
Write-Host "Configuring React project to use environment variable for port..."
Set-Content ..\.env @'
PORT=3006
'@

Write-Host "frontend-react setup complete."

# docker-compose.ymlの設定
Write-Host "Writing docker-compose.yml..."
Set-Content ..\docker-compose.yml @'
services:
  mysql:
    image: mysql:8.0
    container_name: mysql
    ports:
      - "3306:3306"
    volumes:
      - ./docker/mysql/init.d:/docker-entrypoint-initdb.d
      - ./docker/mysql/data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    hostname: mysql
    restart: always
    user: root

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin
    restart: always
    ports:
      - "86:80"
    environment:
      PMA_HOST: mysql
      PMA_PORT: 3306
      PMA_USER: ${MYSQL_USER}
      PMA_PASSWORD: ${MYSQL_PASSWORD}
    depends_on:
      - mysql
'@

# .envの設定
Write-Host "Writing .env..."
Set-Content ..\.env @'
# 共通の環境変数
MYSQL_ROOT_PASSWORD=root_zenpass
MYSQL_DATABASE=zeninv
MYSQL_USER=zeninvestor
MYSQL_PASSWORD=zenpass

# api-go用の環境変数
API_GO_PORT=8086
API_GO_ENV=development

# frontend-react用の環境変数
PORT=3006
REACT_APP_TITLE=ZenInvestor
REACT_APP_API_URL=http://localhost:8086
'@

# .gitignoreの設定
Write-Host "Writing .gitignore..."
Set-Content ..\.gitignore @'
# Node.js
node_modules/
npm-debug.log
yarn-error.log

# Python
__pycache__/
*.py[cod]
venv/

# Go
go.mod
go.sum
tmp/

# Docker
docker/

# .env
.env
'@

# docker-composeの実行
Write-Host "Running docker-compose..."
docker-compose up -d

Write-Host "Setup complete. Please verify the installations and configurations."
