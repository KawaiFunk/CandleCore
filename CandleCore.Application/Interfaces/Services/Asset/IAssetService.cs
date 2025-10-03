using CandleCore.Domain.Entities.Asset;
using CandleCore.Interfaces.Services.Generic;

namespace CandleCore.Interfaces.Services.Asset;

public interface IAssetService : IGenericService<AssetEntity>
{
    Task UpsertAsync(AssetEntity                  entity);
    Task BulkUpsertAsync(IEnumerable<AssetEntity> entities);
}