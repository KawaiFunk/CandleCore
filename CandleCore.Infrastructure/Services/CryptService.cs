using CandleCore.Interfaces.Services;

namespace CandleCore.Infrastructure.Services;

public class CryptService : ICryptService
{
    public string Hash(string password) =>
        BCrypt.Net.BCrypt.HashPassword(password, workFactor: 12, enhancedEntropy: false);

    public bool Verify(string password, string hash) =>
        BCrypt.Net.BCrypt.Verify(password, hash, enhancedEntropy: false);
}
