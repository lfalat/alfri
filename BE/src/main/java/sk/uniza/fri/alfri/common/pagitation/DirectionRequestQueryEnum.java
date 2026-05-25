package sk.uniza.fri.alfri.common.pagitation;

import java.util.Locale;
import java.util.Optional;

public enum DirectionRequestQueryEnum {

    ASC, DESC;

    public static DirectionRequestQueryEnum fromString(String value) {

        try {
            return DirectionRequestQueryEnum.valueOf(value.toUpperCase(Locale.US));
        } catch (Exception e) {
            throw new IllegalArgumentException(String.format(
                    "Invalid value '%s' for orders given! Has to be either 'desc' or 'asc' (case insensitive).",
                    value), e);
        }
    }

    public static Optional<DirectionRequestQueryEnum> fromOptionalString(String value) {

        try {
            return Optional.of(fromString(value));
        } catch (IllegalArgumentException e) {
            return Optional.empty();
        }
    }
}
