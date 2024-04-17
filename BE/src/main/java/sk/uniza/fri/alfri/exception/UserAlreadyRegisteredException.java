package sk.uniza.fri.alfri.exception;

/** Created by petos on 28/03/2024. */
public class UserAlreadyRegisteredException extends Exception {
    public UserAlreadyRegisteredException(String message) {
        super(message);
    }
}
