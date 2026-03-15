using CandleCore.Domain.Common.PagedList;

namespace CandleCore.Models.Asset;

public enum AssetSortField
{
    Rank,
    Price,
    Change1h,
    Name,
    MarketCap
}

public enum AssetChangeFilter
{
    All,
    Gainers,
    Losers
}

public class AssetFilter : PagedListFilter
{
    public AssetSortField   SortBy        { get; set; } = AssetSortField.Rank;
    public AssetChangeFilter ChangeFilter { get; set; } = AssetChangeFilter.All;
    public decimal?          PriceMin     { get; set; }
    public decimal?          PriceMax     { get; set; }
}
