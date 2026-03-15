using CandleCore.Models.Trigger;

namespace CandleCore.Interfaces.Services.Trigger;

public interface ITriggerService
{
    Task<List<TriggerModel>> GetByUserIdAsync(int userId);
    Task<TriggerModel>       CreateAsync(int userId, CreateTriggerModel model);
    Task<TriggerModel>       ToggleActiveAsync(int userId, int triggerId);
    Task                     DeleteAsync(int userId, int triggerId);
}
