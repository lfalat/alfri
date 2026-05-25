package sk.uniza.fri.alfri.common.pagitation;

import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Order;

import java.util.List;
import java.util.stream.Collectors;

public class SortAssembler {
    public static Sort from(SortDefinition source) {
        if (source == null) {
            return null;
        }
        List<Order> orders = source.getOrders().stream()
                .map(o -> from(o.getDirection(), o.getProperty())).collect(Collectors.toList());
        return Sort.by(orders);
    }

    private static Order from(DirectionRequestQueryEnum direction, String property) {
        return switch (direction) {
            case ASC -> Order.asc(property);
            case DESC -> Order.desc(property);
        };
    }
}
