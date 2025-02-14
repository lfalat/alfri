import os
import logging
import warnings
import sys
import json
import numpy as np

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # FATAL
stderr = sys.stderr
sys.stderr = open(os.devnull, 'w')

import tensorflow as tf
tf.get_logger().setLevel(tf.compat.v1.logging.FATAL)
tf.compat.v1.logging.set_verbosity(tf.compat.v1.logging.ERROR)
logging.getLogger('tensorflow').setLevel(tf.compat.v1.logging.FATAL)

sys.stderr = stderr

import absl.logging
logging.root.removeHandler(absl.logging._absl_handler)
absl.logging._warn_preinit_stderr = False

# Decode map for predictions
DECODE_MAP = {
    0: "A",
    1: "B",
    2: "C",
    3: "D",
    4: "E",
    5: "Fx",
    6: "*"
}

def load_models(model_paths):
    """
    Load TensorFlow models from provided paths.
    :param model_paths: Dictionary with subject names as keys and paths to models as values.
    :return: Dictionary with loaded models.
    """
    models = {}
    for subject, path in model_paths.items():
        try:
            models[subject] = tf.keras.models.load_model(path, compile=False)
        except Exception as e:
            models[subject] = None  # Mark this model as not loadable
    return models

def run_model(model, input_data):
    """
    Run inference for a specific model with the provided input data.
    :param model: The TensorFlow model to use for inference.
    :param input_data: A list of input features for the model.
    :return: The decoded predicted mark.
    """
    if model is None:
        return "Error: Model not loaded"

    input_array = np.array([input_data])
    predictions = model.predict(input_array, verbose=0)
    predicted_category = np.argmax(predictions, axis=1)[0]
    return DECODE_MAP.get(predicted_category, "Unknown")

def main():
    """
    Main entry point for the script.
    Expects:
    - JSON string with input data (first argument)
    - JSON string with model paths (second argument)
    """
    if len(sys.argv) != 3:
        sys.exit(1)

    try:
        input_data = json.loads(sys.argv[1])
        model_paths = json.loads(sys.argv[2])
    except json.JSONDecodeError:
        sys.exit(1)

    if "data" not in input_data or not isinstance(input_data["data"], dict):
        sys.exit(1)

    encoded_marks_dict = input_data["data"]
    models = load_models(model_paths)

    results = {}
    for subject_name, model in models.items():
        subject_input = encoded_marks_dict.get(subject_name)
        if subject_input is None:
            sys.exit(1)
        results[subject_name] = run_model(model, subject_input)
    print(json.dumps(results, indent=4))

if __name__ == "__main__":
    main()
