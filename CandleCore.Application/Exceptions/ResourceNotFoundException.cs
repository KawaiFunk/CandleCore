namespace CandleCore.Exceptions;

public class ResourceNotFoundException(string resourceName, object key)
    : AppException($"{resourceName} with key '{key}' was not found.", ErrorCodes.NotFound)
{
    public string ResourceName { get; } = resourceName;
    public object Key          { get; } = key;
}