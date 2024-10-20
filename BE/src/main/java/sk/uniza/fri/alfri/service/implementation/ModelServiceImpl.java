package sk.uniza.fri.alfri.service.implementation;

import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.dto.models.PredictionInput;
import sk.uniza.fri.alfri.dto.models.PredictionOutput;
import sk.uniza.fri.alfri.feignclients.ModelExternalClient;
import sk.uniza.fri.alfri.service.ModelService;

@Service
public class ModelServiceImpl implements ModelService {
    private final ModelExternalClient modelExternalClient;

    public ModelServiceImpl(ModelExternalClient modelExternalClient) {
        this.modelExternalClient = modelExternalClient;
    }

    @Override
    public PredictionOutput predictDummyModel(PredictionInput input) {
        return this.modelExternalClient.predictDummyModel(input);
    }
}
