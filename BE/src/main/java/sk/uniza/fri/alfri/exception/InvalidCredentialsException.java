package sk.uniza.fri.alfri.exception;

import java.io.Serial;

public class InvalidCredentialsException extends RuntimeException {
    @Serial
    private static final long serialVersionUID = -7152824033002191983L;

    public InvalidCredentialsException(String message) {
        super(message);
    }
}
