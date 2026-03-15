using CandleCore.Models.Asset;

namespace CandleCore.Interfaces.Services.Favorite;

public interface IFavoriteService
{
    Task<List<AssetModel>> GetFavoritesAsync(int userId);
    Task                   AddAsync(int         userId, int assetId);
    Task                   RemoveAsync(int      userId, int assetId);
}
