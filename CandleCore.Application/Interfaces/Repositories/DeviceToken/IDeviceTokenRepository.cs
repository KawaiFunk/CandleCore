namespace CandleCore.Interfaces.Repositories.DeviceToken;

public interface IDeviceTokenRepository
{
    Task        UpsertAsync(int userId, string token);
    Task<string?> GetTokenByUserIdAsync(int userId);
}
