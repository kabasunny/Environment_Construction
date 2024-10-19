# SetupFrontendReact.ps1
Function SetupFrontendReact {
    Write-Host "Setting up frontend-react project..."
    Set-Location frontend-react

    Write-Host "Creating React + TypeScript project..."
    npx create-react-app . --template typescript

    Write-Host "Installing additional libraries..."
    npm install axios react-router-dom prop-types redux react-redux styled-components formik yup

    Write-Host "Creating .env file for frontend-react..."
    $frontendEnvContent = @'
PORT=3006
REACT_APP_TITLE=ZenInvestor
REACT_APP_API_URL=http://localhost:8086
'@
    Set-Content .\.env $frontendEnvContent

    Write-Host "frontend-react setup complete."
    Set-Location ..
}

SetupFrontendReact
