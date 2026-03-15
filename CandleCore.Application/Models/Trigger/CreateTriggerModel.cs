using CandleCore.Models.Trigger.Enum;

namespace CandleCore.Models.Trigger;

public class CreateTriggerModel
{
    public int            AssetId     { get; set; }
    public AlarmCondition Condition   { get; set; }
    public decimal        TargetPrice { get; set; }
}
