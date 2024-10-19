# 新しいターミナルを立ち上げ、./api-go/に移動して air コマンドを実行
Start-Process powershell -ArgumentList "Start-Process powershell -ArgumentList 'cd ./api-go/; air; Pause'"

# 新しいターミナルを立ち上げ、./frontend-react/に移動して npm start コマンドを実行
Start-Process powershell -ArgumentList "Start-Process powershell -ArgumentList 'cd ./frontend-react/; npm start; Pause'"

# 新しいターミナルを立ち上げ、./data-analysis-python/src/に移動して python ./app.py コマンドを実行
Start-Process powershell -ArgumentList "Start-Process powershell -ArgumentList 'cd ./data-analysis-python/src/; python ./app.py; Pause'"
