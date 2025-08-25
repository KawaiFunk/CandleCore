namespace CandleCore.Infrastructure.Options.Coinlore;

public class CoinloreOptions
{
    public string ApiKey        { get; set; }
    public string BaseUrl       { get; set; }
    public int    TickerLimit   { get; set; }
    public int    TickerBatches { get; set; }
}