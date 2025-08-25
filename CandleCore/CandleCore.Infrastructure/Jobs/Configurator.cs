using CandleCore.Infrastructure.Jobs.Asset;
using CandleCore.Interfaces.Jobs;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Jobs;

public static class Configurator
{
    public static void AddJobs(this IServiceCollection serviceCollection)
    {
        serviceCollection.AddScoped<IAssetSyncJob, AssetSyncJob>();
    }
}