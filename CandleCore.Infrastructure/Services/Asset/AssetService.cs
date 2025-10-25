using CandleCore.Domain.Common.PagedList;
using CandleCore.Domain.Entities.Asset;
using CandleCore.Infrastructure.Services.Generic;
using CandleCore.Interfaces.Repositories.Asset;
using CandleCore.Interfaces.Repositories.Generic;
using CandleCore.Interfaces.Services.Asset;
using CandleCore.Mappers;

namespace CandleCore.Infrastructure.Services.Asset;

public class AssetService(
    IGenericRepository<AssetEntity> repository,
    IAssetMapper                    mapper,
    IAssetRepository                assetRepository)
    : GenericService<AssetEntity>(repository), IAssetService
{
    public async Task UpsertAsync(AssetEntity entity)
    {
        var existingAsset = await assetRepository.GetByExternalIdAsync(entity.ExternalId);

        if (existingAsset == null)
        {
            await assetRepository.AddAsync(entity);
        }
        else
        {
            mapper.MapToExisting(entity, existingAsset);
            await assetRepository.UpdateAsync(existingAsset);
        }
    }

    public async Task BulkUpsertAsync(IEnumerable<AssetEntity> entities)
    {
        await assetRepository.BulkUpsertAsync(entities);
    }

    public new async Task<IPagedList<AssetEntity>> GetAllPagedAsync(PagedListFilter filter)
    {
        return await assetRepository.GetAllPagedAsync(filter);
    }
}