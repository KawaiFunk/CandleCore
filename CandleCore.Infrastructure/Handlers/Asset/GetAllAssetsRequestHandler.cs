using CandleCore.Domain.Common.PagedList;
using CandleCore.Interfaces.Services.Asset;
using CandleCore.Mappers;
using CandleCore.Models.Asset;
using Domain.Common.PagedList;
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
        try
        {
            logger.LogInformation("Fetching all assets paged");
            var assets = await assetService.GetAllPagedAsync(request.Filter);

            return assets.ToMappedPaged(assetMapper.Map);
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex);
            throw;
        }
    }
}

public class GetAllAssetsRequest(PagedListFilter filter) : IRequest<IPagedList<AssetModel>>
{
    public PagedListFilter Filter { get; set; } = filter;
}