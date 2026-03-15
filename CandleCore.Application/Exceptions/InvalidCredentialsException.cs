namespace CandleCore.Application.Exceptions;

public class InvalidCredentialsException()
    : AppException("Invalid username or password.", ErrorCodes.InvalidCredentials);
