package sk.uniza.fri.alfri.infrastructure.exception;

/**
 * Marker exception to classify Python service 5xx responses as retryable and circuit-breaker recorded failures.
 */
public class PythonServiceServerException extends RuntimeException {
    public PythonServiceServerException(String message) {
        super(message);
    }
    public PythonServiceServerException(String message, Throwable cause) {
        super(message, cause);
    }
}

