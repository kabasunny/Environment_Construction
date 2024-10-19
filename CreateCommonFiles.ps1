# CreateCommonFiles.ps1
Function CreateCommonFiles {
    Write-Host "Creating common files..."

    Write-Host "Creating .env file..."
    $envContent = @'
# Common environment variables
MYSQL_ROOT_PASSWORD=root_zenpass
MYSQL_DATABASE=zeninv
MYSQL_USER=zeninvestor
MYSQL_PASSWORD=zenpass

# api-go environment variables
API_GO_PORT=8086
API_GO_ENV=development

# frontend-react environment variables are in frontend-react/
'@
    Set-Content .env $envContent

    Write-Host "Creating .gitignore file..."
    $gitignoreContent = @'
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
    Set-Content .gitignore $gitignoreContent

    Write-Host "Creating docker-compose.yml file..."
    $dockerComposeContent = @'
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
    Set-Content docker-compose.yml $dockerComposeContent

    Write-Host "Common files creation complete."
}

CreateCommonFiles
