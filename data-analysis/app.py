from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/ping", methods=["GET"])
def ping():
    return jsonify({"message": "pong"})


# 株価データの分析APIを追加

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
