namespace CandleCore.Application.Exceptions;

public class DuplicateResourceException(string resourceName, string field, object value)
    : AppException($"{resourceName} with {field} '{value}' already exists.", ErrorCodes.DuplicateResource)
{
    public string ResourceName { get; } = resourceName;
    public string Field        { get; } = field;
    public object Value        { get; } = value;
}
