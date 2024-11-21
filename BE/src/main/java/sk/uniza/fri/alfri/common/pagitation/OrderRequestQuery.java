package sk.uniza.fri.alfri.common.pagitation;

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

    public DirectionRequestQueryEnum getDirection() {
        return this.direction;
    }

    public String getProperty() {
        return this.property;
    }

    public String toString() {
        return "SortRequestQuery.OrderRequestQuery(direction=" + this.getDirection() + ", property=" + this.getProperty() + ")";
    }
}
