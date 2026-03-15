using CandleCore.Domain.Entities.Asset;
using CandleCore.Domain.Entities.Favorite;
using CandleCore.Interfaces.Repositories.Favorite;
using Microsoft.EntityFrameworkCore;

namespace CandleCore.Infrastructure.Persistence.Repositories.Favorite;

public class FavoriteRepository(CandleCoreDbContext context) : IFavoriteRepository
{
    public async Task<List<AssetEntity>> GetFavoritesAsync(int userId)
    {
        return await context.Set<UserFavoriteEntity>()
            .Where(f => f.UserId == userId)
            .Join(context.Set<AssetEntity>(),
                f => f.AssetId,
                a => a.Id,
                (_, a) => a)
            .AsNoTracking()
            .ToListAsync();
    }

    public async Task AddAsync(int userId, int assetId)
    {
        if (!await ExistsAsync(userId, assetId))
        {
            context.Set<UserFavoriteEntity>().Add(new UserFavoriteEntity
            {
                UserId  = userId,
                AssetId = assetId
            });
            await context.SaveChangesAsync();
        }
    }

    public async Task RemoveAsync(int userId, int assetId)
    {
        var entity = await context.Set<UserFavoriteEntity>()
            .FirstOrDefaultAsync(f => f.UserId == userId && f.AssetId == assetId);

        if (entity != null)
        {
            context.Set<UserFavoriteEntity>().Remove(entity);
            await context.SaveChangesAsync();
        }
    }

    public async Task<bool> ExistsAsync(int userId, int assetId)
    {
        return await context.Set<UserFavoriteEntity>()
            .AnyAsync(f => f.UserId == userId && f.AssetId == assetId);
    }
}
