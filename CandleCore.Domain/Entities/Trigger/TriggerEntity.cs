using CandleCore.Domain.Entities.Generic;

namespace CandleCore.Domain.Entities.Trigger;

public class TriggerEntity : BaseEntity
{
    public int            UserId      { get; set; }
    public int            AssetId     { get; set; }
    public string         AssetName   { get; set; } = string.Empty;
    public AlarmCondition Condition   { get; set; }
    public decimal        TargetPrice { get; set; }
    public bool           IsActive    { get; set; } = true;
    public DateTime?      TriggeredAt { get; set; }
}
