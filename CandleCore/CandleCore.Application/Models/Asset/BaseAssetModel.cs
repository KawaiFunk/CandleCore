namespace CandleCore.Models.Asset;

public class BaseAssetModel
{
    public string  Symbol          { get; set; } = string.Empty;
    public string  Name            { get; set; } = string.Empty;
    public decimal PriceUsd        { get; set; }
    public decimal PercentChange1h { get; set; }
}