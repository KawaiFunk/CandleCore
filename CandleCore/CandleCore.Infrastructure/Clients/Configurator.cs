using CandleCore.Infrastructure.Clients.Coinlore;
using CandleCore.Infrastructure.Options.Coinlore;
using CandleCore.Interfaces.Clients;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace CandleCore.Infrastructure.Clients;

public static class Configurator
{
    public static void AddClients(this IServiceCollection services)
    {
        services.AddHttpClient<IAssetClient, CoinloreClient>((sp, client) =>
        {
            var options = sp.GetRequiredService<IOptions<CoinloreOptions>>().Value;

            client.BaseAddress = new Uri(options.BaseUrl);
            client.DefaultRequestHeaders.Add("Accept", "application/json");
        });
    }
}