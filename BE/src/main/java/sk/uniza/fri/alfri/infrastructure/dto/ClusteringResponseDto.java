package sk.uniza.fri.alfri.infrastructure.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Setter
@Getter
public class ClusteringResponseDto {
    // new/desired fields (match the Python JSON response)
    private Integer studyProgramId;
    private String method;
    private List<SelectedSubjectDto> selectedSubjects;
    private List<Double> centroid;
    private List<Integer> selectedClusters;
    private List<RecommendationDto> recommendations;

    // legacy fields kept for backward compatibility with older python service responses
    @JsonProperty("offset_applied")
    private int offset_applied;

    @JsonProperty("cluster_indices")
    private List<Integer> cluster_indices;

    // convenience accessor: returns whichever list is populated (new or legacy)
    public List<Integer> getCluster_indices() {
        if (this.cluster_indices != null) return this.cluster_indices;
        return this.selectedClusters;
    }

    @Setter
    @Getter
    public static class SelectedSubjectDto {
        private Integer id;
        private String name;
        private String code;

        @JsonProperty("cluster_label")
        private Integer clusterLabel;
    }

    @Setter
    @Getter
    public static class RecommendationDto {
        private Integer id;
        private String name;
        private String code;
        private String abbreviation;

        @JsonProperty("cluster_label")
        private Integer clusterLabel;

        private Double distance;

        @JsonProperty("similarity_score")
        private Double similarityScore;
    }
}
