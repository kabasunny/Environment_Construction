from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'


@app.route("/plot")
def plot():
    # yfinanceを使ってチE�Eタを取征E
    stock = yf.Ticker("AAPL")  # Appleの株
    data = stock.history(period="1mo")  # 過去1ヶ月�EチE�Eタを取征E

    # グラフを作�E
    plt.figure(figsize=(10, 5))
    plt.plot(data.index, data["Close"], label="Close Price", color="blue")
    plt.title("AAPL Stock Price")
    plt.xlabel("Date")
    plt.ylabel("Price (USD)")
    plt.legend()

    # グラフをバイナリストリームに保孁E
    img = io.BytesIO()
    plt.savefig(img, format="png")
    img.seek(0)  # ストリームのポインタを�E頭に戻ぁE
    plt.close()  # プロチE��を閉じる

    # グラフをブラウザに返す
    return send_file(img, mimetype="image/png")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5006, debug=True)
