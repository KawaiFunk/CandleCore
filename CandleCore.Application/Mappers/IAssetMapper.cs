using CandleCore.Domain.Entities.Asset;
using CandleCore.Models.Asset;

namespace CandleCore.Mappers;

public interface IAssetMapper
{
    AssetModel         Map(AssetEntity             entity);
    DetailedAssetModel MapDetailed(AssetEntity     entity);
    AssetEntity        ToEntity(CoinloreAssetModel model);
    void               MapToExisting(AssetEntity   source, AssetEntity target);
}