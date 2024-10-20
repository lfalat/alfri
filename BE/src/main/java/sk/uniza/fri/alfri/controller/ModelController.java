package sk.uniza.fri.alfri.controller;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.dto.models.PredictionInput;
import sk.uniza.fri.alfri.dto.models.PredictionOutput;
import sk.uniza.fri.alfri.service.ModelService;

@RestController
@RequestMapping("/api/model")
public class ModelController {
    private final ModelService modelService;

    public ModelController(ModelService modelService) {
        this.modelService = modelService;
    }

    @PostMapping(value = "/predict-dummy", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public PredictionOutput predictDummy(@RequestBody PredictionInput predictionInput) {
        return this.modelService.predictDummyModel(predictionInput);
    }
}
