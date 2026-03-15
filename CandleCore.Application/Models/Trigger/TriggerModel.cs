using CandleCore.Models.Trigger.Enum;

namespace CandleCore.Models.Trigger;

public class TriggerModel
{
    public int            Id           { get; set; }
    public int            UserId       { get; set; }
    public int            AssetId      { get; set; }
    public string         AssetName    { get; set; } = string.Empty;
    public AlarmCondition Condition    { get; set; }
    public decimal        TargetPrice  { get; set; }
    public bool           IsActive     { get; set; }
    public DateTime?      TriggeredAt  { get; set; }
    public DateTime       CreatedAtUtc { get; set; }
}
