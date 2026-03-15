using CandleCore.Domain.Entities.User;
using CandleCore.Interfaces.Repositories.DeviceToken;
using Microsoft.EntityFrameworkCore;

namespace CandleCore.Infrastructure.Persistence.Repositories.DeviceToken;

public class DeviceTokenRepository(CandleCoreDbContext context) : IDeviceTokenRepository
{
    public async Task UpsertAsync(int userId, string token)
    {
        var existing = await context.Set<DeviceTokenEntity>()
            .FirstOrDefaultAsync(d => d.UserId == userId);

        if (existing != null)
        {
            existing.Token = token;
            existing.UpdatedAtUtc = DateTime.UtcNow;
        }
        else
        {
            context.Set<DeviceTokenEntity>().Add(new DeviceTokenEntity
            {
                UserId = userId,
                Token  = token,
            });
        }

        await context.SaveChangesAsync();
    }

    public async Task<string?> GetTokenByUserIdAsync(int userId)
    {
        return await context.Set<DeviceTokenEntity>()
            .Where(d => d.UserId == userId)
            .Select(d => d.Token)
            .FirstOrDefaultAsync();
    }
}
