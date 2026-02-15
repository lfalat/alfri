package sk.uniza.fri.alfri.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import sk.uniza.fri.alfri.client.dto.*;

@FeignClient(name = "python-ml-client", url = "${python.service.base-url}")
public interface PythonMlClient {

    @PostMapping(value = "/api/v1/predictions/passing-chance", consumes = MediaType.APPLICATION_JSON_VALUE)
    PassingChanceResponseDto passingChance(@RequestBody PassingChanceRequestDto request);

    @PostMapping(value = "/api/v1/predictions/passing-mark", consumes = MediaType.APPLICATION_JSON_VALUE)
    PassingMarkResponseDto passingMark(@RequestBody PassingMarkRequestDto request);

    @PostMapping(value = "/api/v1/clustering/recommend", consumes = MediaType.APPLICATION_JSON_VALUE)
    ClusteringResponseDto clustering(@RequestBody ClusteringRequestDto request);

    @PostMapping(value = "/api/v1/predictions/trigger")
    void triggerPrediction();

    @GetMapping(value = "/api/v1/predictions/test")
    ResponseEntity<String> test();
}
