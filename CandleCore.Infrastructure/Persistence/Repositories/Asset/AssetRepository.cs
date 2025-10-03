using CandleCore.Domain.Entities.Asset;
using CandleCore.Infrastructure.Persistence.Repositories.Generic;
using CandleCore.Interfaces.Repositories.Asset;
using EFCore.BulkExtensions;
using Microsoft.EntityFrameworkCore;

namespace CandleCore.Infrastructure.Persistence.Repositories.Asset;

public class AssetRepository(CandleCoreDbContext context) : GenericRepository<AssetEntity>(context), IAssetRepository
{
    public async Task<AssetEntity?> GetByExternalIdAsync(string externalId)
    {
        return await Table.FirstOrDefaultAsync(a => a.ExternalId == externalId);
    }

    public async Task BulkUpsertAsync(IEnumerable<AssetEntity> entities)
    {
        await context.BulkInsertOrUpdateAsync(entities, new BulkConfig
        {
            UpdateByProperties = ["ExternalId"],
            BatchSize = 100
        });
    }
}