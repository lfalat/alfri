package sk.uniza.fri.alfri.common.pagitation;


import lombok.Getter;

@Getter
public class PageDefinition {
    private final int size;
    private final int page;
    private final SortDefinition sort;

    public PageDefinition(int page, int size, SortDefinition sort) {
        this.page = page;
        this.size = size;
        this.sort = sort;
    }

}
