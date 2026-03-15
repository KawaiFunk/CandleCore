using CandleCore.Domain.Entities.Asset;
using CandleCore.Domain.Entities.Trigger;
using CandleCore.Interfaces.Repositories.Trigger;
using Microsoft.EntityFrameworkCore;

namespace CandleCore.Infrastructure.Persistence.Repositories.Trigger;

public class TriggerRepository(CandleCoreDbContext context) : ITriggerRepository
{
    public async Task<List<TriggerEntity>> GetByUserIdAsync(int userId)
    {
        return await context.Set<TriggerEntity>()
            .Where(t => t.UserId == userId)
            .OrderByDescending(t => t.CreatedAtUtc)
            .AsNoTracking()
            .ToListAsync();
    }

    public async Task<TriggerEntity?> GetByIdAsync(int id)
    {
        return await context.Set<TriggerEntity>()
            .FirstOrDefaultAsync(t => t.Id == id);
    }

    public async Task<TriggerEntity> CreateAsync(TriggerEntity trigger)
    {
        context.Set<TriggerEntity>().Add(trigger);
        await context.SaveChangesAsync();
        return trigger;
    }

    public async Task<TriggerEntity> UpdateAsync(TriggerEntity trigger)
    {
        context.Set<TriggerEntity>().Update(trigger);
        await context.SaveChangesAsync();
        return trigger;
    }

    public async Task DeleteAsync(TriggerEntity trigger)
    {
        context.Set<TriggerEntity>().Remove(trigger);
        await context.SaveChangesAsync();
    }

    public async Task<List<TriggerEntity>> GetTriggeredCandidatesAsync()
    {
        return await context.Set<TriggerEntity>()
            .Where(t => t.IsActive)
            .Join(
                context.Set<AssetEntity>(),
                t => t.AssetId,
                a => a.Id,
                (t, a) => new { Trigger = t, Asset = a })
            .Where(x =>
                (x.Trigger.Condition == AlarmCondition.Above && x.Asset.PriceUsd >= x.Trigger.TargetPrice) ||
                (x.Trigger.Condition == AlarmCondition.Below && x.Asset.PriceUsd <= x.Trigger.TargetPrice))
            .Select(x => x.Trigger)
            .ToListAsync();
    }

    public async Task<string?> GetAssetNameAsync(int assetId)
    {
        return await context.Set<AssetEntity>()
            .Where(a => a.Id == assetId)
            .Select(a => a.Name)
            .FirstOrDefaultAsync();
    }

    public async Task<decimal?> GetCurrentPriceAsync(int assetId)
    {
        return await context.Set<AssetEntity>()
            .Where(a => a.Id == assetId)
            .Select(a => (decimal?)a.PriceUsd)
            .FirstOrDefaultAsync();
    }
}
