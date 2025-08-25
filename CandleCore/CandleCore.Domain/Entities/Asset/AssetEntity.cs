using CandleCore.Domain.Entities.Generic;

namespace CandleCore.Domain.Entities.Asset;

public class AssetEntity : BaseEntity
{
    public string  ExternalId       { get; set; } = string.Empty;
    public string  Symbol           { get; set; } = string.Empty;
    public string  Name             { get; set; } = string.Empty;
    public int     Rank             { get; set; }
    public decimal PriceUsd         { get; set; }
    public decimal PercentChange24h { get; set; }
    public decimal PercentChange1h  { get; set; }
    public decimal PercentChange7d  { get; set; }
    public decimal PriceBtc         { get; set; }
    public decimal MarketCapUsd     { get; set; }
    public decimal Volume24a        { get; set; }
}