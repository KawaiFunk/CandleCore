using CandleCore.Models.Asset;

namespace CandleCore.Interfaces.Clients;

public interface IAssetClient
{
    Task<CoinloreAssetListModel> GetCryptoAssetsAsync(int startIndex);
}