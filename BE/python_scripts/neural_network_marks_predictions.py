import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'

import json
import sys
import tensorflow as tf
import numpy as np

# Example structure of model_paths input:
# {
#    "Matematicka analyza 1": "./best_models/mata1.h5",
#    "Diskretna pravdepodobnost": "./best_models/dp.h5",
#    "Algoritmy a udajove struktury 1": "./best_models/aus1.h5"
#}

# Define the decoding mapping for predicted grades.
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
            models[subject] = tf.keras.models.load_model(path)
        except Exception as e:
            print(f"Error loading model for {subject}: {e}")
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

    # Convert input data to numpy array
    input_array = np.array([input_data])

    # Perform inference without verbose logging
    predictions = model.predict(input_array, verbose=0)

    # Get the predicted category (highest probability)
    predicted_category = np.argmax(predictions, axis=1)[0]

    # Decode the predicted category
    return DECODE_MAP.get(predicted_category, "Unknown")


def main():
    """
    Main entry point for the script.
    Expects:
    - JSON string with input data (first argument)
    - JSON string with model paths (second argument)

    input_data example:
    {
       "data": {
           "Matematicka analyza 1": [0, 0, 0],
           "Algoritmy a udajove struktury 1": [0, 0]
       }
    }

    model_paths example:
    {
       "Matematicka analyza 1": "./best_models/mata1.h5",
       "Algoritmy a udajove struktury 1": "./best_models/aus1.h5"
    }
    """

    if len(sys.argv) != 3:
        print("Usage: python run_models.py <input_json> <model_paths_json>")
        sys.exit(1)

    # Parse input data
    input_json = sys.argv[1]
    try:
        input_data = json.loads(input_json)
    except json.JSONDecodeError:
        print("Invalid JSON input.")
        sys.exit(1)

    # Parse model paths
    model_paths_json = sys.argv[2]
    try:
        model_paths = json.loads(model_paths_json)
    except json.JSONDecodeError:
        print("Invalid JSON model paths.")
        sys.exit(1)

    # Ensure input data is structured correctly
    if "data" not in input_data:
        print("Input JSON must contain a 'data' field with a dictionary of subject->input.")
        sys.exit(1)

    encoded_marks_dict = input_data["data"]
    if not isinstance(encoded_marks_dict, dict):
        print("The 'data' field must be a dictionary mapping each subject to its input array.")
        sys.exit(1)

    # Load models
    models = load_models(model_paths)

    # Run models and collect results
    results = {}
    for subject_name, model in models.items():
        subject_input = encoded_marks_dict.get(subject_name)
        if subject_input is None:
            print(f"No input data provided for subject: {subject_name}")
            sys.exit(1)

        results[subject_name] = run_model(model, subject_input)

    # Return results as JSON
    print(json.dumps(results, indent=4))


if __name__ == "__main__":
    main()
