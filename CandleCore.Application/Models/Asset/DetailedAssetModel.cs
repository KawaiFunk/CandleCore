namespace CandleCore.Models.Asset;

public class DetailedAssetModel : BaseAssetModel
{
    public int     Id               { get; set; }
    public int     Rank             { get; set; }
    public decimal PriceBtc         { get; set; }
    public decimal MarketCapUsd     { get; set; }
    public decimal Volume24a        { get; set; }
    public decimal PercentChange24h { get; set; }
    public decimal PercentChange7d  { get; set; }
}