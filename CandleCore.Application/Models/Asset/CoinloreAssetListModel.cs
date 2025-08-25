using System.Text.Json.Serialization;

namespace Application.Models.Assets;

public class CoinloreAssetListModel
{
    [JsonPropertyName("data")]
    public List<CoinloreAssetModel>? Data { get; set; }
}