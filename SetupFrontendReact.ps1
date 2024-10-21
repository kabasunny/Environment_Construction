Function SetupFrontendReact {
    Write-Host "Setting up frontend-react project with Vite..."

    # Node.js のインストール確認
    Write-Host "Checking if Node.js is installed..."
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-Host "Node.js is not installed. Installing Node.js..."
        Invoke-WebRequest -Uri https://nodejs.org/dist/v20.17.0/node-v20.17.0-x64.msi -OutFile nodejs.msi
        Start-Process -Wait -FilePath nodejs.msi -ArgumentList "/S"
        Remove-Item nodejs.msi

        # Node.js がインストールされたか確認
        if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
            Write-Host "Failed to install Node.js. Please install Node.js manually." -ForegroundColor Red
            exit
        }
    } else {
        Write-Host "Node.js is already installed."
    }

    # npmの最新バージョンをインストール
    Write-Host "Updating npm to the latest version..."
    npm install -g npm

    # frontend-react ディレクトリに移動して Vite プロジェクトを作成
    Set-Location ../frontend-react

    Write-Host "Creating Vite + React + TypeScript project..."
    npx create-vite@latest . --template react-ts

    # 依存パッケージのインストール
    Write-Host "Installing dependencies..."
    npm install

    # 追加のライブラリをインストール
    Write-Host "Installing additional libraries..."
    npm install axios react-router-dom prop-types redux react-redux styled-components formik yup

    # .env ファイルの作成
    Write-Host "Creating .env file for frontend-react..."
    $frontendEnvContent = @'
PORT=3006
VITE_APP_TITLE=ZenInvestor
VITE_APP_API_URL=http://localhost:8086
'@
    Set-Content -Path ".env" -Value $frontendEnvContent -Encoding utf8

    Write-Host "frontend-react setup complete."
    Set-Location ../Environment_Construction
}

# 関数を呼び出す
SetupFrontendReact
