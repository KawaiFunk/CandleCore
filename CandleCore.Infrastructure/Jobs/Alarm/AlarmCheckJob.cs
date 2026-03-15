using CandleCore.Interfaces.Clients;
using CandleCore.Interfaces.Jobs;
using CandleCore.Interfaces.Repositories.DeviceToken;
using CandleCore.Interfaces.Repositories.Trigger;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Jobs.Alarm;

public class AlarmCheckJob(
    ITriggerRepository     triggerRepository,
    IDeviceTokenRepository deviceTokenRepository,
    IFcmClient             fcmClient,
    ILogger<AlarmCheckJob> logger) : IAlarmCheckJob
{
    public async Task CheckAlarmsAsync()
    {
        try
        {
            logger.LogInformation("Starting Alarm Check Job");

            var candidates = await triggerRepository.GetTriggeredCandidatesAsync();

            logger.LogInformation("Found {Count} triggered alarms", candidates.Count);

            foreach (var trigger in candidates)
            {
                trigger.TriggeredAt  = DateTime.UtcNow;
                trigger.IsActive     = false;
                trigger.UpdatedAtUtc = DateTime.UtcNow;

                await triggerRepository.UpdateAsync(trigger);

                var deviceToken = await deviceTokenRepository.GetTokenByUserIdAsync(trigger.UserId);

                if (deviceToken == null)
                    continue;

                var conditionLabel = trigger.Condition == Domain.Entities.Trigger.AlarmCondition.Above
                    ? "above"
                    : "below";

                await fcmClient.SendAsync(
                    deviceToken,
                    "Price Alert Triggered",
                    $"{trigger.AssetName} is now {conditionLabel} ${trigger.TargetPrice:F2}");
            }

            logger.LogInformation("Alarm Check Job completed");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error occurred during Alarm Check Job: {Message}", ex.Message);
            throw;
        }
    }
}
