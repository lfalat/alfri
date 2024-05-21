package sk.uniza.fri.alfri.common.pagitation;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

@Data
public class PageDTO<T> {
    int currentPage;
    int pageSize;
    long totalElements;
    int totalPages;
    List<T> content;

    @JsonProperty
    boolean hasNextPage() {
        return this.currentPage + 1 < this.totalPages;
    }

    @JsonProperty
    boolean hasPreviousPage() {
        return this.currentPage > 0;
    }
}
