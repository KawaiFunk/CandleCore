using System.Text.Json.Serialization;

namespace CandleCore.Models.Asset;

public class CoinloreAssetModel
{
    [JsonPropertyName("id")]
    public string Id { get; set; } = string.Empty;

    [JsonPropertyName("symbol")]
    public string Symbol { get; set; } = string.Empty;

    [JsonPropertyName("name")]
    public string Name { get; set; } = string.Empty;

    [JsonPropertyName("rank")]
    public int Rank { get; set; }

    [JsonPropertyName("price_usd")]
    public string PriceUsd { get; set; } = string.Empty;

    [JsonPropertyName("percent_change_24h")]
    public string PercentChange24h { get; set; } = string.Empty;

    [JsonPropertyName("percent_change_1h")]
    public string PercentChange1h { get; set; } = string.Empty;

    [JsonPropertyName("percent_change_7d")]
    public string PercentChange7d { get; set; } = string.Empty;

    [JsonPropertyName("price_btc")]
    public string PriceBtc { get; set; } = string.Empty;

    [JsonPropertyName("market_cap_usd")]
    public string MarketCapUsd { get; set; } = string.Empty;

    [JsonPropertyName("volume24")]
    public decimal Volume24a { get; set; }
}