using CandleCore.Domain.Common.PagedList;
using CandleCore.Interfaces.Services.Asset;
using CandleCore.Mappers;
using CandleCore.Models.Asset;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.Asset;

public class GetAllAssetsRequestHandler(
    ILogger<GetAllAssetsRequestHandler> logger,
    IAssetService                       assetService,
    IAssetMapper                        assetMapper)
    : IRequestHandler<GetAllAssetsRequest, IPagedList<AssetModel>>
{
    public async Task<IPagedList<AssetModel>> Handle(GetAllAssetsRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Fetching all assets — page {Page}, size {Size}",
            request.Filter.PageNumber, request.Filter.PageSize);

        var assets = await assetService.GetAllPagedAsync(request.Filter);

        return assets.ToMappedPaged(assetMapper.Map);
    }
}

public class GetAllAssetsRequest(PagedListFilter filter) : IRequest<IPagedList<AssetModel>>
{
    public PagedListFilter Filter { get; } = filter;
}
