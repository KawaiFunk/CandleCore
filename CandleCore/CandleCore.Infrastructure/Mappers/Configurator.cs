using CandleCore.Infrastructure.Mappers.Asset;
using CandleCore.Mappers;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Mappers;

public static class Configurator
{
    public static void AddMappers(this IServiceCollection services)
    {
        services.AddScoped<IAssetMapper, AssetMapper>();
    }
}