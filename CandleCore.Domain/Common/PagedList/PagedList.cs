using CandleCore.Domain.Common.PagedList;

namespace Domain.Common.PagedList;

public class PagedList<T> : IPagedList<T>
{
    public int            PageNumber      { get; set; }
    public int            PageSize        { get; set; }
    public int            TotalCount      { get; set; }
    public int            TotalPages      { get; set; }
    public bool           HasPreviousPage => PageNumber > 1;
    public bool           HasNextPage     => PageNumber < TotalPages;
    public IEnumerable<T> Data            { get; set; }
}