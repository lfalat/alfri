package sk.uniza.fri.alfri.common.pagitation;

import lombok.Getter;

import java.util.List;

@Getter
public class SortDefinition {

    public List<OrderRequestQuery> orders;

    public SortDefinition(List<OrderRequestQuery> orders) {
        this.orders = orders;
    }

    public static SortDefinition by(List<OrderRequestQuery> ordersList) {
        return new SortDefinition(ordersList);
    }

}
