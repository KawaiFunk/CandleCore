using CandleCore.Domain.Entities.Asset;
using CandleCore.Interfaces.Repositories.Generic;

namespace CandleCore.Interfaces.Repositories.Asset;

public interface IAssetRepository : IGenericRepository<AssetEntity>
{
    Task<AssetEntity?> GetByExternalIdAsync(string              externalId);
    Task               BulkUpsertAsync(IEnumerable<AssetEntity> entities);
}