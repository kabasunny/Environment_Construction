# main.ps1
# ZenInvestor セットアップのメインスクリプト

# スクリプトの実行前に Set-ExecutionPolicy RemoteSigned を実行してください

# 各スクリプトをインポートして実行
. .\CreateDirectoryStructure.ps1
. .\SetupGoEnvironment.ps1
. .\SetupApiGo.ps1
. .\SetupDataAnalysisPython.ps1
. .\SetupFrontendReact.ps1
. .\CreateCommonFiles.ps1
. .\RunDockerCompose.ps1

Write-Host "fin"