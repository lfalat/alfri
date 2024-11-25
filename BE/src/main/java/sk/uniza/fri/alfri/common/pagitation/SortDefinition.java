package sk.uniza.fri.alfri.common.pagitation;

import java.util.List;

public class SortDefinition {

  public List<OrderRequestQuery> orders;

  public SortDefinition(List<OrderRequestQuery> orders) {
    this.orders = orders;
  }

  public static SortDefinition by(List<OrderRequestQuery> ordersList) {
    return new SortDefinition(ordersList);
  }

  public List<OrderRequestQuery> getOrders() {
    return this.orders;
  }
}
