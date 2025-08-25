using CandleCore.Infrastructure.Options.Coinlore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Options;

public static class Configurator
{
    public static void AddCustomOptions(this IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<CoinloreOptions>(configuration.GetSection("Coinlore"));
    }
}