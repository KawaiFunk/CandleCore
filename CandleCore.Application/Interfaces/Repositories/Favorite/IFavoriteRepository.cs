using CandleCore.Domain.Entities.Asset;

namespace CandleCore.Interfaces.Repositories.Favorite;

public interface IFavoriteRepository
{
    Task<List<AssetEntity>> GetFavoritesAsync(int userId);
    Task                    AddAsync(int          userId, int assetId);
    Task                    RemoveAsync(int       userId, int assetId);
    Task<bool>              ExistsAsync(int       userId, int assetId);
}