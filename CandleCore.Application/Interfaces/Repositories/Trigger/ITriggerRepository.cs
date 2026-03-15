using CandleCore.Domain.Entities.Trigger;

namespace CandleCore.Interfaces.Repositories.Trigger;

public interface ITriggerRepository
{
    Task<List<TriggerEntity>>  GetByUserIdAsync(int userId);
    Task<TriggerEntity?>       GetByIdAsync(int id);
    Task<TriggerEntity>        CreateAsync(TriggerEntity trigger);
    Task<TriggerEntity>        UpdateAsync(TriggerEntity trigger);
    Task                       DeleteAsync(TriggerEntity trigger);
    Task<List<TriggerEntity>>  GetTriggeredCandidatesAsync();
    Task<string?>              GetAssetNameAsync(int assetId);
    Task<decimal?>             GetCurrentPriceAsync(int assetId);
}
