package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.infrastructure.dto.*;

public interface PythonPredictionService {
    PassingChanceResponseDto passingChance(PassingChanceRequestDto request);
    PassingMarkResponseDto passingMark(PassingMarkRequestDto request);
    ClusteringResponseDto clustering(ClusteringRequestDto request);
    void triggerPrediction();
}

