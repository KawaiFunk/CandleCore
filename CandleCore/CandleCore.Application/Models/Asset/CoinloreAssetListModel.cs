using System.Text.Json.Serialization;

namespace CandleCore.Models.Asset;

public class CoinloreAssetListModel
{
    [JsonPropertyName("data")]
    public List<CoinloreAssetModel>? Data { get; set; }
}