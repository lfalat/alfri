package sk.uniza.fri.alfri.common.pagitation;

import java.util.List;
import java.util.stream.Collectors;

public class SortRequestQuery {
    public static SortDefinition from(SortDefinition source) {
        if (source == null) {
            return null;
        }

        List<OrderRequestQuery> orders =
                source.orders.stream().map(SortRequestQuery::from).collect(Collectors.toList());
        SortDefinition sort = new SortDefinition(orders);
        return sort;
    }

    private static OrderRequestQuery from(OrderRequestQuery source) {
        return switch (source.direction) {
            case ASC -> new OrderRequestQuery(DirectionRequestQueryEnum.ASC, source.property);
            case DESC -> new OrderRequestQuery(DirectionRequestQueryEnum.DESC, source.property);
            default -> throw new IllegalArgumentException("Undefined sort order type");
        };
    }
}
