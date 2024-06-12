package sk.uniza.fri.alfri.common.pagitation;


public class PageDefinition {
    private final int size;
    private final int page;
    private final SortDefinition sort;

    public PageDefinition(int page, int size, SortDefinition sort) {
        this.page = page;
        this.size = size;
        this.sort = sort;
    }

    public int getSize() {
        return size;
    }

    public int getPage() {
        return page;
    }

    public SortDefinition getSort() {
        return this.sort;
    }
}
