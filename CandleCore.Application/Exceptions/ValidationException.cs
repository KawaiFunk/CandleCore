namespace CandleCore.Exceptions;

public class ValidationException(string message)
    : AppException(message, ErrorCodes.ValidationError);
