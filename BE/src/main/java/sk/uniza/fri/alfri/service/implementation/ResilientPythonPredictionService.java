package sk.uniza.fri.alfri.service.implementation;

import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import io.github.resilience4j.retry.annotation.Retry;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.infrastructure.PythonMlClient;
import sk.uniza.fri.alfri.infrastructure.dto.*;
import sk.uniza.fri.alfri.service.PythonPredictionService;

@Service
@RequiredArgsConstructor
@Slf4j
public class ResilientPythonPredictionService implements PythonPredictionService {

    private final PythonMlClient pythonMlClient;

    @Override
    @Retry(name = "pythonServiceRetry")
    @CircuitBreaker(name = "pythonService", fallbackMethod = "passingChanceFallback")
    public PassingChanceResponseDto passingChance(PassingChanceRequestDto request) {
        return pythonMlClient.passingChance(request);
    }

    public PassingChanceResponseDto passingChanceFallback(PassingChanceRequestDto request, Throwable t) {
        log.warn("passingChance fallback due to: {}", t.toString());
        PassingChanceResponseDto resp = new PassingChanceResponseDto();
        // return empty results to indicate graceful degradation
        resp.setResults(java.util.Collections.emptyMap());
        return resp;
    }

    @Override
    @Retry(name = "pythonServiceRetry")
    @CircuitBreaker(name = "pythonService", fallbackMethod = "passingMarkFallback")
    public PassingMarkResponseDto passingMark(PassingMarkRequestDto request) {
        return pythonMlClient.passingMark(request);
    }

    @Override
    @Retry(name = "pythonServiceRetry")
    @CircuitBreaker(name = "pythonService", fallbackMethod = "clusteringFallback")
    public ClusteringResponseDto clustering(ClusteringRequestDto request) {
        return pythonMlClient.clustering(request);
    }

    @Override
    @Retry(name = "pythonServiceRetry")
    @CircuitBreaker(name = "pythonService", fallbackMethod = "triggerPredictionFallback")
    public void triggerPrediction() {
        pythonMlClient.triggerPrediction();
    }
}

