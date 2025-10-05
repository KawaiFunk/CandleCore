using CandleCore.Domain.Common.PagedList;

namespace Domain.Common.PagedList;

public static class PagedListExtensions
{
    public static IPagedList<TDestination> ToMappedPaged<TSource, TDestination>(
        this IPagedList<TSource>    list,
        Func<TSource, TDestination> selector)
    {
        return new PagedList<TDestination>
        {
            PageNumber = list.PageNumber,
            PageSize   = list.PageSize,
            TotalCount = list.TotalCount,
            TotalPages = list.TotalPages,
            Data       = list.Data.Select(selector).ToList()
        };
    }
}