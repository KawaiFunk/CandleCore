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
            Name            = entity.Name,
            Symbol          = entity.Symbol,
            PriceUsd        = entity.PriceUsd,
            PercentChange1h = entity.PercentChange1h
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

    public CoinloreAssetModel ToCoinloreModel(AssetEntity entity)
    {
        return new CoinloreAssetModel
        {
            Id               = entity.ExternalId,
            Symbol           = entity.Symbol,
            Name             = entity.Name,
            Rank             = entity.Rank,
            PriceUsd         = entity.PriceUsd.ToString(),
            PercentChange24h = entity.PercentChange24h.ToString(),
            PercentChange1h  = entity.PercentChange1h.ToString(),
            PercentChange7d  = entity.PercentChange7d.ToString(),
            PriceBtc         = entity.PriceBtc.ToString(),
            MarketCapUsd     = entity.MarketCapUsd.ToString(),
            Volume24a        = entity.Volume24a
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