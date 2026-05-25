package sk.uniza.fri.alfri.common.pagitation;

public class PagitationRequestQuery {
    public int page;
    public int size;
    public String search;
    public SortDefinition sort;

    public static PagitationRequestQuery of(int page, int size, String search, SortDefinition sort) {
        PagitationRequestQuery pageRequest = new PagitationRequestQuery();
        pageRequest.page = page;
        pageRequest.size = size;
        pageRequest.search = search;
        pageRequest.sort = sort;
        return pageRequest;
    }
}
