"""
This is a flask victim service that just generatesa random number 
"""
from flask import Flask, jsonify
import datetime
import random

app = Flask(__name__)

@app.route("/")
def home():
  return f"<html><body><h1>Lucky number generator:</h1><p>Your lucky number is: {random.randint(1, 100)}</p></body></html>"

@app.route("/number")
def json_response():
  return jsonify({
      "lucky_number": random.randint(1, 100)
  })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
