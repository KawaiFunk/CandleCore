using CandleCore.Domain.Entities.Asset;
using CandleCore.Infrastructure.Services.Generic;
using CandleCore.Interfaces.Repositories.Asset;
using CandleCore.Interfaces.Repositories.Generic;
using CandleCore.Interfaces.Services.Asset;
using CandleCore.Mappers;
using Domain.Common.PagedList;

namespace CandleCore.Infrastructure.Services.Asset;

public class AssetService(
    IGenericRepository<AssetEntity> repository,
    IAssetMapper                    mapper,
    IAssetRepository                assetRepository)
    : GenericService<AssetEntity>(repository), IAssetService
{
    private readonly IAssetRepository _assetRepository = assetRepository;
    private readonly IAssetMapper     _mapper          = mapper;

    public async Task UpsertAsync(AssetEntity entity)
    {
        var existingAsset = await _assetRepository.GetByExternalIdAsync(entity.ExternalId);

        if (existingAsset == null)
        {
            await _assetRepository.AddAsync(entity);
        }
        else
        {
            _mapper.MapToExisting(entity, existingAsset);
            await _assetRepository.UpdateAsync(existingAsset);
        }
    }

    public new async Task<IPagedList<AssetEntity>> GetAllPagedAsync(PagedListFilter filter)
    {
        return await _assetRepository.GetAllPagedAsync(filter);
    }
}