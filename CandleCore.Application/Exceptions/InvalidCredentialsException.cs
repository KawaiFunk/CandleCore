namespace CandleCore.Exceptions;

public class InvalidCredentialsException()
    : AppException("Invalid username or password.", ErrorCodes.InvalidCredentials);