using System.Text.Json;
using CandleCore.Infrastructure.Helpers.Coinlore;
using CandleCore.Infrastructure.Options.Coinlore;
using CandleCore.Interfaces.Clients;
using CandleCore.Models.Asset;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace CandleCore.Infrastructure.Clients.Coinlore;

public class CoinloreClient(
    HttpClient                httpClient,
    IOptions<CoinloreOptions> coinloreOptions,
    ILogger<CoinloreClient>   logger
    ) : IAssetClient
{
    public async Task<CoinloreAssetListModel> GetCryptoAssetsAsync(int startIndex)
    {
        logger.LogInformation("Getting crypto assets from the coinlore client");
        var requestUrl = CoinloreRoutes.Ticker(startIndex, coinloreOptions.Value.TickerLimit);
        var response   = await httpClient.GetAsync(requestUrl);
        
        if (!response.IsSuccessStatusCode)
        {
            logger.LogError("Failed to fetch assets from Coinlore. Status Code: {StatusCode}", response.StatusCode);
            throw new Exception($"Error fetching assets: {response.ReasonPhrase}");
        }

        var content = await response.Content.ReadAsStringAsync();
        var result = JsonSerializer.Deserialize<CoinloreAssetListModel>(content,
            new JsonSerializerOptions
            {
                PropertyNamingPolicy        = JsonNamingPolicy.SnakeCaseLower,
                PropertyNameCaseInsensitive = true
            });

        if (result == null)
        {
            logger.LogWarning("No assets found in the response from Coinlore");
            throw new Exception("No assets found in the response.");
        }
        
        return result;
    }
}