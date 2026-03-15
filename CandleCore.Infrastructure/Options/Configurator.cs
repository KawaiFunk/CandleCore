using CandleCore.Infrastructure.Options.Coinlore;
using CandleCore.Infrastructure.Options.Fcm;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Options;

public static class Configurator
{
    public static void AddCustomOptions(this IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<CoinloreOptions>(configuration.GetSection("Coinlore"));
        services.Configure<FcmOptions>(configuration.GetSection("Fcm"));
    }
}