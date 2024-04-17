package sk.uniza.fri.alfri.exception;

public class UserAlreadyRegisteredException extends RuntimeException {
  public UserAlreadyRegisteredException(String message) {
    super(message);
  }
}
