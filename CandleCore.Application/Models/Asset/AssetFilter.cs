using CandleCore.Domain.Common.PagedList;
using CandleCore.Models.Asset.Enum;

namespace CandleCore.Models.Asset;

public class AssetFilter : PagedListFilter
{
    public AssetSortField    SortBy       { get; set; } = AssetSortField.Rank;
    public AssetChangeFilter ChangeFilter { get; set; } = AssetChangeFilter.All;
    public decimal?          PriceMin     { get; set; }
    public decimal?          PriceMax     { get; set; }
}