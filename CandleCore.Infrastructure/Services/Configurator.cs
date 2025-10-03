using CandleCore.Infrastructure.Services.Asset;
using CandleCore.Infrastructure.Services.Generic;
using CandleCore.Interfaces.Services.Asset;
using CandleCore.Interfaces.Services.Generic;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Services;

public static class Configurator
{
    public static void AddServices(this IServiceCollection services)
    {
        services.AddScoped(typeof(IGenericService<>), typeof(GenericService<>));
        services.AddScoped<IAssetService, AssetService>();
    }
}