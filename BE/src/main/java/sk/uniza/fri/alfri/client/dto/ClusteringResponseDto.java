package sk.uniza.fri.alfri.client.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Setter
@Getter
public class ClusteringResponseDto {
    private String studyProgramId;
    private int offset_applied;
    private List<Integer> cluster_indices;
    private List<Double> centroid;

}

