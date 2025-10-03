using CandleCore.Infrastructure.Options.Coinlore;
using CandleCore.Interfaces.Clients;
using CandleCore.Interfaces.Jobs;
using CandleCore.Interfaces.Services.Asset;
using CandleCore.Mappers;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace CandleCore.Infrastructure.Jobs.Asset;

public class AssetSyncJob(
    IAssetService             assetService, 
    IAssetMapper              assetMapper,
    IAssetClient              assetClient,
    ILogger<AssetSyncJob>     logger, 
    IOptions<CoinloreOptions> options
    ) : IAssetSyncJob
{
    public async Task SyncAssetsAsync()
    {
        var batchSize  = options.Value.TickerLimit;
        var batchCount = options.Value.TickerBatches;

        try
        {
            logger.LogInformation("Starting Asset Sync Job");
            for (var i = 0; i < batchCount; i++)
            {
                var startIndex = i * batchSize;
                logger.LogInformation("Fetching assets batch {Batch} starting at index {Index}", i + 1, startIndex);
                var assetList = await assetClient.GetCryptoAssetsAsync(startIndex);
                
                if (assetList?.Data == null || assetList.Data.Count == 0)
                {
                    logger.LogWarning("No assets found in batch {Batch}", i + 1);
                    continue;
                }
                
                var assetEntities = assetList.Data.Select(assetMapper.ToEntity).ToList();
                await assetService.BulkUpsertAsync(assetEntities);
                logger.LogInformation("Upserted {Count} assets from batch {Batch}", assetEntities.Count, i + 1);
            }
            
            logger.LogInformation("Asset Sync Job completed successfully");
        }
        catch (Exception e)
        {
            logger.LogError(e, "Error occurred during Asset Sync Job: {Message}", e.Message);
            throw;
        }
    }
}