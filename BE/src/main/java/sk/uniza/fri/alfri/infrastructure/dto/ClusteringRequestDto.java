package sk.uniza.fri.alfri.infrastructure.dto;

import java.util.List;

public class ClusteringRequestDto {
    private List<Integer> subjectIds;
    private Integer studyProgramId;
    private Integer n_clusters;

    public List<Integer> getSubjectIds() {
        return subjectIds;
    }

    public void setSubjectIds(List<Integer> subjectIds) {
        this.subjectIds = subjectIds;
    }

    public Integer getStudyProgramId() {
        return studyProgramId;
    }

    public void setStudyProgramId(Integer studyProgramId) {
        this.studyProgramId = studyProgramId;
    }

    public Integer getN_clusters() {
        return n_clusters;
    }

    public void setN_clusters(Integer n_clusters) {
        this.n_clusters = n_clusters;
    }
}

