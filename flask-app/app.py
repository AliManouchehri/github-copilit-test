from flask import Flask, render_template, request, jsonify

app = Flask(__name__)


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/api/greet", methods=["POST"])
def greet():
    data = request.get_json()
    name = data.get("name", "World")
    return jsonify({"message": f"Hello, {name}!"})


if __name__ == "__main__":
    app.run(debug=True, port=5000)
