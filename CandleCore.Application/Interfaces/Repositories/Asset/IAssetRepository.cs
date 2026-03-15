using CandleCore.Domain.Common.PagedList;
using CandleCore.Domain.Entities.Asset;
using CandleCore.Interfaces.Repositories.Generic;
using CandleCore.Models.Asset;

namespace CandleCore.Interfaces.Repositories.Asset;

public interface IAssetRepository : IGenericRepository<AssetEntity>
{
    Task<AssetEntity?>            GetByExternalIdAsync(string              externalId);
    Task                          BulkUpsertAsync(IEnumerable<AssetEntity> entities);
    Task<IPagedList<AssetEntity>> GetAllPagedAsync(AssetFilter             filter);
}