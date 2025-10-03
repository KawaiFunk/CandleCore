using CandleCore.Infrastructure.Persistence.Repositories.Asset;
using CandleCore.Infrastructure.Persistence.Repositories.Generic;
using CandleCore.Interfaces.Repositories.Asset;
using CandleCore.Interfaces.Repositories.Generic;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Persistence.Repositories;

public static class Configurator
{
    public static void AddRepositories(this IServiceCollection services)
    {
        services.AddScoped(typeof(IGenericRepository<>), typeof(GenericRepository<>));
        services.AddScoped<IAssetRepository, AssetRepository>();
    }
}