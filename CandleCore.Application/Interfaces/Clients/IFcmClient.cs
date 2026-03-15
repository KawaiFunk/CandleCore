namespace CandleCore.Interfaces.Clients;

public interface IFcmClient
{
    Task SendAsync(string deviceToken, string title, string body);
}
