namespace CandleCore.Domain.Entities.Generic;

public interface IBaseEntity
{
    int      Id           { get; set; }
    DateTime CreatedAtUtc { get; set; }
    DateTime UpdatedAtUtc { get; set; }
}