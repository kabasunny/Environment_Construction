Function SetupDataAnalysisPython {
    Write-Host "Setting up data-analysis-python project..."

    # Check if running as administrator
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Host "This script must be run as an administrator. Please restart PowerShell as administrator." -ForegroundColor Red
        exit
    }

    # Create data-analysis-python directory if it doesn't exist
    $projectDir = Join-Path (Get-Location) "../data-analysis-python"
    if (-not (Test-Path $projectDir)) {
        New-Item -Path $projectDir -ItemType Directory
    }

    Write-Host "Checking directory permissions..."
    $acl = Get-Acl $projectDir
    if (-not $acl.AccessToString.Contains("FullControl")) {
        Write-Host "You do not have the necessary permissions for this directory. Please run as administrator or change directory permissions." -ForegroundColor Red
        exit
    }

    Write-Host "Checking if Python is installed..."
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
        Write-Host "Python is not installed. Installing Python 3.11..."
        $pythonInstaller = "python-3.11.0-amd64.exe"
        Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.11.0/$pythonInstaller" -OutFile $pythonInstaller

        Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait

        # Clean up the installer
        Remove-Item $pythonInstaller

        # Check if Python was successfully installed
        if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
            Write-Host "Failed to install Python. Please install Python 3.11 manually from https://www.python.org/downloads/ and rerun the script." -ForegroundColor Red
            exit
        }
    } else {
        Write-Host "Python is already installed."
    }

    Write-Host "Creating Python virtual environment in 'data-analysis-python'..."
    python -m venv "$projectDir\venv"

    # Check if venv was created successfully
    if (-not (Test-Path "$projectDir\venv\Scripts\Activate.ps1")) {
        Write-Host "Failed to create virtual environment. Please check the Python installation and retry." -ForegroundColor Red
        exit
    }

    Write-Host "Activating Python virtual environment..."
    # Activating the environment using PowerShell
    & "$projectDir\venv\Scripts\Activate.ps1"

    Write-Host "Virtual environment activated."

    Write-Host "Creating requirements.txt..."
    $requirementsContent = @'
Flask
pandas
matplotlib
seaborn
waitress
numpy
lightgbm
yfinance
'@
    Set-Content "$projectDir\requirements.txt" $requirementsContent

    Write-Host "Installing required libraries..."
    python -m pip install --upgrade pip
    python -m pip install -r "$projectDir\requirements.txt"

    Write-Host "Creating sample app.py..."
    $appPyContent = @'
from flask import Flask, send_file
import yfinance as yf
import matplotlib.pyplot as plt
import io

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "Hello, World!"

@app.route("/plot")
def plot():
    stock = yf.Ticker("AAPL")
    data = stock.history(period="1mo")
    plt.figure(figsize=(10, 5))
    plt.plot(data.index, data["Close"], label="Close Price", color="blue")
    plt.title("AAPL Stock Price")
    plt.xlabel("Date")
    plt.ylabel("Price (USD)")
    plt.legend()
    img = io.BytesIO()
    plt.savefig(img, format="png")
    img.seek(0)
    plt.close()
    return send_file(img, mimetype="image/png")

if __name__ == "__main__": 
    app.run(host="0.0.0.0", port=5006, debug=True)
'@
    $srcDir = Join-Path $projectDir "src"
    if (-not (Test-Path $srcDir)) {
        New-Item -Path $srcDir -ItemType Directory
    }
    Set-Content "$srcDir\app.py" $appPyContent

    Write-Host "data-analysis-python project setup complete."
    Set-Location $projectDir
    Set-Location ../Environment_Construction
}

SetupDataAnalysisPython
