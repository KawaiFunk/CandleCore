using CandleCore.Domain.Entities.Asset;
using CandleCore.Mappers;
using CandleCore.Models.Asset;

namespace CandleCore.Infrastructure.Mappers.Asset;

public class AssetMapper : IAssetMapper
{
    public AssetModel Map(AssetEntity entity)
    {
        return new AssetModel
        {
            Id              = entity.Id,
            Name            = entity.Name,
            Symbol          = entity.Symbol,
            PriceUsd        = entity.PriceUsd,
            PercentChange1h = entity.PercentChange1h
        };
    }

    public DetailedAssetModel MapDetailed(AssetEntity entity)
    {
        return new DetailedAssetModel
        {
            Id               = entity.Id,
            Name             = entity.Name,
            Symbol           = entity.Symbol,
            Rank             = entity.Rank,
            PriceUsd         = entity.PriceUsd,
            PriceBtc         = entity.PriceBtc,
            MarketCapUsd     = entity.MarketCapUsd,
            Volume24a        = entity.Volume24a,
            PercentChange1h  = entity.PercentChange1h,
            PercentChange24h = entity.PercentChange24h,
            PercentChange7d  = entity.PercentChange7d,
        };
    }

    public AssetEntity ToEntity(CoinloreAssetModel model)
    {
        return new AssetEntity
        {
            ExternalId       = model.Id,
            Symbol           = model.Symbol,
            Name             = model.Name,
            Rank             = model.Rank,
            PriceUsd         = decimal.TryParse(model.PriceUsd, out var priceUsd) ? priceUsd : 0,
            PercentChange24h = decimal.TryParse(model.PercentChange24h, out var pc24h) ? pc24h : 0,
            PercentChange1h  = decimal.TryParse(model.PercentChange1h, out var pc1h) ? pc1h : 0,
            PercentChange7d  = decimal.TryParse(model.PercentChange7d, out var pc7d) ? pc7d : 0,
            PriceBtc         = decimal.TryParse(model.PriceBtc, out var priceBtc) ? priceBtc : 0,
            MarketCapUsd     = decimal.TryParse(model.MarketCapUsd, out var marketCapUsd) ? marketCapUsd : 0,
            Volume24a        = model.Volume24a
        };
    }

    public void MapToExisting(AssetEntity source, AssetEntity target)
    {
        target.Rank             = source.Rank;
        target.PriceUsd         = source.PriceUsd;
        target.PercentChange24h = source.PercentChange24h;
        target.PercentChange1h  = source.PercentChange1h;
        target.PercentChange7d  = source.PercentChange7d;
        target.PriceBtc         = source.PriceBtc;
        target.MarketCapUsd     = source.MarketCapUsd;
        target.Volume24a        = source.Volume24a;
    }
}