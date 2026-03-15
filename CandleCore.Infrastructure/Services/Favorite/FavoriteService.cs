using CandleCore.Interfaces.Repositories.Favorite;
using CandleCore.Interfaces.Services.Favorite;
using CandleCore.Mappers;
using CandleCore.Models.Asset;

namespace CandleCore.Infrastructure.Services.Favorite;

public class FavoriteService(
    IFavoriteRepository favoriteRepository,
    IAssetMapper        assetMapper)
    : IFavoriteService
{
    public async Task<List<AssetModel>> GetFavoritesAsync(int userId)
    {
        var entities = await favoriteRepository.GetFavoritesAsync(userId);
        return entities.Select(assetMapper.Map).ToList();
    }

    public async Task AddAsync(int userId, int assetId)
    {
        await favoriteRepository.AddAsync(userId, assetId);
    }

    public async Task RemoveAsync(int userId, int assetId)
    {
        await favoriteRepository.RemoveAsync(userId, assetId);
    }
}
