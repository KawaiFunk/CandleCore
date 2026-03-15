using CandleCore.Domain.Common.PagedList;
using CandleCore.Domain.Entities.Asset;
using CandleCore.Interfaces.Services.Generic;
using CandleCore.Models.Asset;

namespace CandleCore.Interfaces.Services.Asset;

public interface IAssetService : IGenericService<AssetEntity>
{
    Task UpsertAsync(AssetEntity                              entity);
    Task BulkUpsertAsync(IEnumerable<AssetEntity>            entities);
    Task<IPagedList<AssetEntity>> GetAllPagedAsync(AssetFilter filter);
}