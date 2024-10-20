package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.dto.models.PredictionInput;
import sk.uniza.fri.alfri.dto.models.PredictionOutput;

public interface ModelService {
    PredictionOutput predictDummyModel(PredictionInput input);
}
