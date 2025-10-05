namespace CandleCore.Domain.Common.PagedList;

public interface IPagedList<T>
{
    int            PageNumber      { get; set; }
    int            PageSize        { get; set; }
    int            TotalCount      { get; set; }
    int            TotalPages      { get; set; }
    bool           HasPreviousPage { get; }
    bool           HasNextPage     { get; }
    IEnumerable<T> Data            { get; set; }
}