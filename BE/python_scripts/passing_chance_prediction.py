import os
import warnings

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
warnings.filterwarnings('ignore')


import json
import sys
import pickle
import numpy as np

def load_models(model_paths):
    """
    Load binary LogisticRegression models from provided .pkl paths.
    :param model_paths: Dictionary with subject names as keys and paths to models as values.
    :return: Dictionary with loaded models (or None if load fails).
    """
    models = {}
    for subject, path in model_paths.items():
        try:
            with open(path, "rb") as f:
                models[subject] = pickle.load(f)
        except Exception as e:
            print(f"Error loading model for {subject}: {e}")
            models[subject] = None
    return models

def get_passing_probability(model, input_data):
    """
    Run inference on a binary logistic regression model trained for passing vs. not passing.
    Model’s positive class (label=1) should correspond to “passing”.
    :param model: The logistic regression model to use for inference.
    :param input_data: A list of input features for the model.
    :return: A float representing the probability (0.0 - 1.0) of passing.
    """
    if model is None:
        return None

    X = np.array([input_data], dtype=float)

    passing_prob = model.predict_proba(X)[0][1]
    return float(passing_prob)

def main():
    """
    Main entry point for the script.
    Expects two arguments:
     1) JSON string with input data:
        {
          "data": {
            "Matematicka analyza 1": [feature1, feature2, ...],
            "Diskretna pravdepodobnost": [feature1, feature2, ...],
            ...
          }
        }
     2) JSON string with model paths:
        {
          "Matematicka analyza 1": "./path/to/mata1.pkl",
          "Diskretna pravdepodobnost": "./path/to/dp.pkl",
          ...
        }
    """

    if len(sys.argv) != 3:
        print("Usage: python run_passing_change.py <input_json> <model_paths_json>")
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

    if "data" not in input_data:
        print("Input JSON must contain a 'data' field with a dictionary of subject->input.")
        sys.exit(1)

    encoded_marks_dict = input_data["data"]
    if not isinstance(encoded_marks_dict, dict):
        print("The 'data' field must be a dictionary mapping each subject to its input array.")
        sys.exit(1)

    models = load_models(model_paths)

    results = {}
    for subject_name, model in models.items():
        subject_input = encoded_marks_dict.get(subject_name)
        if subject_input is None:
            print(f"No input data provided for subject: {subject_name}")
            sys.exit(1)
        passing_probability = get_passing_probability(model, subject_input)
        if passing_probability is None:
            results[subject_name] = "Error: Model not loaded"
        else:
            results[subject_name] = f"{passing_probability * 100:.2f}"

    # output
    print(json.dumps(results, indent=4))

if __name__ == "__main__":
    main()
