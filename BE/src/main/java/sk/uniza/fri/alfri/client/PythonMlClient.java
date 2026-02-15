package sk.uniza.fri.alfri.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import sk.uniza.fri.alfri.client.dto.*;

@FeignClient(name = "python-ml-client", url = "${python.service.base-url}", configuration = sk.uniza.fri.alfri.configuration.FeignConfiguration.class)
public interface PythonMlClient {

    @PostMapping(value = "/api/v1/predictions/passing-chance", consumes = MediaType.APPLICATION_JSON_VALUE)
    PassingChanceResponseDto passingChance(@RequestBody PassingChanceRequestDto request);

    @PostMapping(value = "/api/v1/predictions/passing-mark", consumes = MediaType.APPLICATION_JSON_VALUE)
    PassingMarkResponseDto passingMark(@RequestBody PassingMarkRequestDto request);

    @PostMapping(value = "/api/v1/clustering/similar-subjects", consumes = MediaType.APPLICATION_JSON_VALUE)
    ClusteringResponseDto clustering(@RequestBody ClusteringRequestDto request);

    @PostMapping(value = "/api/v1/predictions/trigger")
    void triggerPrediction();
}
