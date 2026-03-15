using CandleCore.Domain.Entities.Trigger;
using CandleCore.Interfaces.Repositories.Trigger;
using CandleCore.Interfaces.Services.Trigger;
using CandleCore.Models.Trigger;

namespace CandleCore.Infrastructure.Services.Trigger;

public class TriggerService(ITriggerRepository triggerRepository) : ITriggerService
{
    public async Task<List<TriggerModel>> GetByUserIdAsync(int userId)
    {
        var entities = await triggerRepository.GetByUserIdAsync(userId);
        return entities.Select(MapToModel).ToList();
    }

    public async Task<TriggerModel> CreateAsync(int userId, CreateTriggerModel model)
    {
        var assetName = await triggerRepository.GetAssetNameAsync(model.AssetId)
                        ?? throw new InvalidOperationException($"Asset {model.AssetId} not found.");

        var entity = new TriggerEntity
        {
            UserId      = userId,
            AssetId     = model.AssetId,
            AssetName   = assetName,
            Condition   = (AlarmCondition)(int)model.Condition,
            TargetPrice = model.TargetPrice,
            IsActive    = true,
        };

        var created = await triggerRepository.CreateAsync(entity);
        return MapToModel(created);
    }

    public async Task<TriggerModel> ToggleActiveAsync(int userId, int triggerId)
    {
        var trigger = await triggerRepository.GetByIdAsync(triggerId);
        if (trigger == null || trigger.UserId != userId)
            throw new InvalidOperationException("Trigger not found.");

        trigger.IsActive     = !trigger.IsActive;
        trigger.UpdatedAtUtc = DateTime.UtcNow;

        var updated = await triggerRepository.UpdateAsync(trigger);
        return MapToModel(updated);
    }

    public async Task DeleteAsync(int userId, int triggerId)
    {
        var trigger = await triggerRepository.GetByIdAsync(triggerId);
        if (trigger == null || trigger.UserId != userId) return;
        await triggerRepository.DeleteAsync(trigger);
    }

    private static TriggerModel MapToModel(TriggerEntity entity) =>
        new()
        {
            Id           = entity.Id,
            UserId       = entity.UserId,
            AssetId      = entity.AssetId,
            AssetName    = entity.AssetName,
            Condition    = (Models.Trigger.Enum.AlarmCondition)(int)entity.Condition,
            TargetPrice  = entity.TargetPrice,
            IsActive     = entity.IsActive,
            TriggeredAt  = entity.TriggeredAt,
            CreatedAtUtc = entity.CreatedAtUtc,
        };
}