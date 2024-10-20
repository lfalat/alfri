import os
import subprocess

from flask import Flask, request, jsonify
from model_manager import make_prediction

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        input_data = request.json.get('input', None)

        if input_data is None:
            return jsonify({"error": "No input data provided"}), 400

        model_name = 'dummy_model.pkl'
        prediction = make_prediction(input_data, model_name)
        return jsonify({"prediction": prediction.tolist()})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/', methods=['GET'])
def hello_world():
    return 'Hello World!'

if __name__ == "__main__":
    app.run(debug=True)
