namespace CandleCore.Domain.Entities.Generic;

public class BaseEntity
{
    public int      Id           { get; set; }
    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAtUtc { get; set; } = DateTime.UtcNow;
}