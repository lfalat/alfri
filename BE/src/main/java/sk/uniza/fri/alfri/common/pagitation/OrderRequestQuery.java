package sk.uniza.fri.alfri.common.pagitation;

import lombok.Getter;

@Getter
public class OrderRequestQuery {

    public DirectionRequestQueryEnum direction;
    public String property;

    public OrderRequestQuery(DirectionRequestQueryEnum direction, String property) {
        this.direction = direction;
        this.property = property;
    }

    public static OrderRequestQuery by(String property) {
        return new OrderRequestQuery(DirectionRequestQueryEnum.ASC, property);
    }

    public String toString() {
        return "SortRequestQuery.OrderRequestQuery(direction=" + this.getDirection() + ", property="
                + this.getProperty() + ")";
    }
}
