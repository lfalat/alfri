package sk.uniza.fri.alfri.common.pagitation;

public class PageDefinition {
    private final int size;
    private final int page;
//    private final SortDefinition sort;

    public PageDefinition(int page, int size) {
        this.page = page;
        this.size = size;
    }

    public int getSize() {
        return size;
    }

    public int getPage() {
        return page;
    }
}
