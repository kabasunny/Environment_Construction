# ベースイメージを指定
FROM golang:1.20-alpine

# 作業ディレクトリを設定
WORKDIR /app

# 依存関係をコピーし、ダウンロード
COPY go.mod ./
COPY go.sum ./
RUN go mod download

# アプリケーションのソースコードをコピー
COPY . .

# アプリケーションをビルド
RUN go build -o /api

# コンテナ起動時に実行されるコマンド
EXPOSE 8080
CMD [ "/api" ]
