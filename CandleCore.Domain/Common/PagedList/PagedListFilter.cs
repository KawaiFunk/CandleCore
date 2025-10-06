namespace CandleCore.Domain.Common.PagedList;

public class PagedListFilter
{
    public int     PageNumber { get; set; } = 1;
    public int     PageSize   { get; set; } = 10;
    public string? Search     { get; set; } = string.Empty;
    public string? SortBy     { get; set; } = "Name";
    public bool    Descending { get; set; } = false;
}