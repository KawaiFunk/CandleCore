using CandleCore.Domain.Common.PagedList;
using CandleCore.Domain.Entities.Generic;
using Domain.Common.PagedList;
using Microsoft.EntityFrameworkCore;

namespace CandleCore.Infrastructure.Helpers.PagedList;

public static class PagedListHelper
{
    public static async Task<IPagedList<T>> ToPagedListAsync<T>(this IQueryable<T> query, PagedListFilter filter)
        where T : BaseEntity
    {
        var totalCount = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(totalCount / (double)filter.PageSize);

        var data = await query
            .Skip((filter.PageNumber - 1) * filter.PageSize)
            .Take(filter.PageSize)
            .ToListAsync();

        return new PagedList<T>
        {
            PageNumber = filter.PageNumber,
            PageSize   = filter.PageSize,
            TotalCount = totalCount,
            TotalPages = totalPages,
            Data       = data
        };
    }
}