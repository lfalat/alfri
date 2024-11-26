package sk.uniza.fri.alfri.common.pagitation;

import java.io.Serial;
import java.io.Serializable;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import java.util.stream.Stream;
import lombok.Generated;
import lombok.Getter;
import sk.uniza.fri.alfri.exception.BadConditionException;

public class SearchCriteria implements Serializable {
  @Serial
  private static final long serialVersionUID = -2273436300154692713L;

  @Getter
  private final String key;
  @Getter
  @Generated
  private final String operation;
  private final List<String> values = new ArrayList<>();

  public SearchCriteria(String key, String operation, String value) {
    this.key = key;
    this.operation = operation;
    this.values.add(value);
  }

  public void addValue(String value) {
    this.values.add(value);
  }

  // Tries to convert the value of the filter to the specified object type
  // TODO implement other data types than string and number
  public <T> Object getFirstValue(Class<T> objectType) {
    boolean isNumeric = Stream.of(this.values.get(0)).filter(s -> s != null && !s.isEmpty())
        .filter(Pattern.compile("\\D").asPredicate().negate()).mapToLong(Long::valueOf).boxed()
        .findAny().isPresent();

    if (isNumeric) {
      try {
        Constructor<T> constructor;
        constructor = objectType.getConstructor(String.class);
        return constructor.newInstance(this.values.get(0));
      } catch (NoSuchMethodException | SecurityException | InstantiationException
          | IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
        throw new BadConditionException("Value: '" + this.values.get(0)
            + "' cant be convert to number. Value must have number format");
      }
    }

    return this.values.get(0);
  }

  public String getFirstValue() {
    return this.values.get(0);
  }
}
