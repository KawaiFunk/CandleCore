using CandleCore.Infrastructure.Services.Asset;
using CandleCore.Infrastructure.Services.Generic;
using CandleCore.Infrastructure.Services.User;
using CandleCore.Interfaces.Services;
using CandleCore.Interfaces.Services.Asset;
using CandleCore.Interfaces.Services.Generic;
using CandleCore.Interfaces.Services.User;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Services;

public static class Configurator
{
    public static void AddServices(this IServiceCollection services)
    {
        services.AddScoped(typeof(IGenericService<>), typeof(GenericService<>));
        services.AddScoped<IAssetService, AssetService>();
        services.AddScoped<IUserService, UserService>();
        services.AddScoped<ICryptService, CryptService>();
    }
}