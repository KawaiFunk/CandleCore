namespace CandleCore.Interfaces.Jobs;

public interface IAssetSyncJob
{
    Task SyncAssetsAsync();
}