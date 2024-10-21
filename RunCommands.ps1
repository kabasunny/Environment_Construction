# StartProjects.ps1
Start-Process powershell -ArgumentList "Start-Process powershell -ArgumentList 'cd ../api-go; air; Pause'"
Start-Process powershell -ArgumentList "Start-Process powershell -ArgumentList 'cd ../data-analysis-python/src; python app.py; Pause'"
Start-Process powershell -ArgumentList "Start-Process powershell -ArgumentList 'cd ../frontend-react; npm start; Pause'"