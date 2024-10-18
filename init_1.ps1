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
# Windows用のGoのインストールはPowerShellでは難しいので、手動でダウンロードを促す。
Write-Host "Please download and install Go 1.23 from https://golang.org/dl/"

# Ginフレームワークをインストール
Write-Host "Installing Gin framework..."
go mod init zeninvestor
go get github.com/gin-gonic/gin

# GORMをインストール
Write-Host "Installing GORM..."
go get gorm.io/gorm
go get gorm.io/driver/mysql

# airをインストール
Write-Host "Installing air for live reload..."
go install github.com/air-verse/air@v1.61.0

# main.goのサンプルコードを記載
Set-Content main.go @'
package main

import (
    "log"
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
    "gorm.io/driver/mysql"
)

type User struct {
    ID       uint   `gorm:"primaryKey"`
    Name     string `gorm:"size:100"`
    Email    string `gorm:"uniqueIndex;size:100"`
    Password string `gorm:"size:255"`
}

func main() {
    router := gin.Default()

    // MySQLへの接続情報
    dsn := "zeninvestor:zenpass@tcp(localhost:3306)/zeninv?charset=utf8mb4&parseTime=True&loc=Local"
    db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
    if err != nil {
        log.Fatal("failed to connect to database:", err)
    }

    router.GET("/migration", func(c *gin.Context) {
        // Userテーブルの存在チェック
        if db.Migrator().HasTable(&User{}) {
            c.JSON(200, gin.H{"message": "User table already exists. Migration skipped."})
            return
        }

        // テーブルの自動マイグレーション
        err := db.AutoMigrate(&User{})
        if err != nil {
            c.JSON(500, gin.H{"error": "failed to migrate database"})
            return
        }

        // ユーザーデータを作成
        users := []User{
            {Name: "Alice", Email: "alice@example.com", Password: "password1"},
            {Name: "Bob", Email: "bob@example.com", Password: "password2"},
            {Name: "Charlie", Email: "charlie@example.com", Password: "password3"},
        }

        // ユーザーデータをデータベースに追加
        for _, user := range users {
            result := db.Create(&user)
            if result.Error != nil {
                c.JSON(500, gin.H{"error": "Failed to insert user: " + result.Error.Error()})
                return
            }
        }

        log.Println("Database connected and User table migrated successfully. Users added.")
        c.JSON(200, gin.H{"message": "Migration completed successfully"})
    })

    router.Run(":8086")
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

# 仮想環境をアクティブにし、必要なライブラリをインストール
Write-Host "Installing required libraries..."
& .\venv\Scripts\Activate.ps1
pip install -r requirements.txt

# app.pyのサンプルコードを記載
Write-Host "Writing app.py..."
Set-Content src\app.py @'
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'


@app.route("/plot")
def plot():
    # yfinanceを使ってデータを取得
    stock = yf.Ticker("AAPL")  # Appleの株
    data = stock.history(period="1mo")  # 過去1ヶ月のデータを取得

    # グラフを作成
    plt.figure(figsize=(10, 5))
    plt.plot(data.index, data["Close"], label="Close Price", color="blue")
    plt.title("AAPL Stock Price")
    plt.xlabel("Date")
    plt.ylabel("Price (USD)")
    plt.legend()

    # グラフをバイナリストリームに保存
    img = io.BytesIO()
    plt.savefig(img, format="png")
    img.seek(0)  # ストリームのポインタを先頭に戻す
    plt.close()  # プロットを閉じる

    # グラフをブラウザに返す
    return send_file(img, mimetype="image/png")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5006, debug=True)
'@

Write-Host "data-analysis-python setup complete."

# frontend-reactのセットアップ
Write-Host "Setting up React project..."
Set-Location ..\frontend-react

# React + TypeScriptプロジェクトの作成
Write-Host "Creating React project with TypeScript..."
npx create-react-app frontend-react --template typescript

# 必要なモジュールのインストール
Write-Host "Installing additional libraries..."
npm install axios react-router-dom prop-types redux react-redux styled-components formik yup

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
