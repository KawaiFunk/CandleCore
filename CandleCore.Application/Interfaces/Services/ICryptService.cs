namespace CandleCore.Interfaces.Services;

public interface ICryptService
{
    string Hash(string   password);
    bool   Verify(string password, string hash);
}