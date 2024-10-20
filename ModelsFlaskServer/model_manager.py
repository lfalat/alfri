import pickle
from config import MODEL_PATH

def load_model(model_name):
    with open(f'{MODEL_PATH}/{model_name}', 'rb') as f:
        model = pickle.load(f)
    return model


def make_prediction(data, model_name):
    model = load_model(model_name)
    prediction = model.predict([data])
    return prediction
