namespace CandleCore.Infrastructure.Helpers.Coinlore;

public static class CoinloreRoutes
{
    public static string Ticker(int startIndex, int limit)
        => $"tickers/?start={startIndex}&limit={limit}";
}