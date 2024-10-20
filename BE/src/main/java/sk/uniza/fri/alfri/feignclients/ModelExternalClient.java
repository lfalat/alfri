package sk.uniza.fri.alfri.feignclients;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import sk.uniza.fri.alfri.dto.models.PredictionInput;
import sk.uniza.fri.alfri.dto.models.PredictionOutput;

/**
 * External service for running prediction models and retrieving the predictions
 */
@FeignClient(name = "modelExternalClient", url = "${external-model-server-url}")
public interface ModelExternalClient {
    @PostMapping("/predict")
    PredictionOutput predictDummyModel(PredictionInput input);
}
