namespace CandleCore.Interfaces.Jobs;

public interface IAlarmCheckJob
{
    Task CheckAlarmsAsync();
}
