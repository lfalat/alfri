package sk.uniza.fri.alfri.exception;

import java.io.Serial;

public class BadConditionException extends RuntimeException {
    @Serial
    private static final long serialVersionUID = 5675562865620958173L;

    public BadConditionException(String message) {
        super(message);
    }
}
