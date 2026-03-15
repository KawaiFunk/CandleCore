using CandleCore.Domain.Common.PagedList;
using CandleCore.Domain.Entities.Asset;
using CandleCore.Domain.Entities.Generic;
using CandleCore.Models.Asset;
using CandleCore.Models.Asset.Enum;
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

    public static async Task<IPagedList<AssetEntity>> ToPagedListAsync(
        this IQueryable<AssetEntity> query, AssetFilter filter)
    {
        query = query.ApplyAssetFilters(filter);

        var totalCount = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(totalCount / (double)filter.PageSize);

        var data = await query
            .Skip((filter.PageNumber - 1) * filter.PageSize)
            .Take(filter.PageSize)
            .ToListAsync();

        return new PagedList<AssetEntity>
        {
            PageNumber = filter.PageNumber,
            PageSize   = filter.PageSize,
            TotalCount = totalCount,
            TotalPages = totalPages,
            Data       = data
        };
    }

    private static IQueryable<AssetEntity> ApplyAssetFilters(
        this IQueryable<AssetEntity> query, AssetFilter filter)
    {
        if (!string.IsNullOrWhiteSpace(filter.Search))
        {
            var term = filter.Search.ToLower();
            query = query.Where(a =>
                a.Name.ToLower().Contains(term) ||
                a.Symbol.ToLower().Contains(term));
        }

        if (filter.PriceMin.HasValue)
            query = query.Where(a => a.PriceUsd >= filter.PriceMin.Value);

        if (filter.PriceMax.HasValue)
            query = query.Where(a => a.PriceUsd <= filter.PriceMax.Value);

        query = filter.ChangeFilter switch
                {
                    AssetChangeFilter.Gainers => query.Where(a => a.PercentChange1h > 0),
                    AssetChangeFilter.Losers => query.Where(a => a.PercentChange1h < 0),
                    _ => query
                };

        query = (filter.SortBy, filter.Descending) switch
                {
                    (AssetSortField.Price, false) => query.OrderBy(a => a.PriceUsd),
                    (AssetSortField.Price, true) => query.OrderByDescending(a => a.PriceUsd),
                    (AssetSortField.Change1h, false) => query.OrderBy(a => a.PercentChange1h),
                    (AssetSortField.Change1h, true) => query.OrderByDescending(a => a.PercentChange1h),
                    (AssetSortField.Name, false) => query.OrderBy(a => a.Name),
                    (AssetSortField.Name, true) => query.OrderByDescending(a => a.Name),
                    (AssetSortField.MarketCap, false) => query.OrderBy(a => a.MarketCapUsd),
                    (AssetSortField.MarketCap, true) => query.OrderByDescending(a => a.MarketCapUsd),
                    (AssetSortField.Rank, false) => query.OrderBy(a => a.Rank),
                    (AssetSortField.Rank, true) => query.OrderByDescending(a => a.Rank),
                    _ => query.OrderBy(a => a.Rank)
                };

        return query;
    }
}