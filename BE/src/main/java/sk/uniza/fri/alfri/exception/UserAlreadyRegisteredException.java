package sk.uniza.fri.alfri.exception;

import java.io.Serial;

public class UserAlreadyRegisteredException extends RuntimeException {
    @Serial
    private static final long serialVersionUID = -5796472975601254310L;

    public UserAlreadyRegisteredException(String message) {
        super(message);
    }
}
