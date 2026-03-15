using CandleCore.Application.Exceptions;
using CandleCore.Interfaces.Services.Asset;
using CandleCore.Mappers;
using CandleCore.Models.Asset;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.Asset;

public class GetAssetByIdRequestHandler(
    ILogger<GetAssetByIdRequestHandler> logger,
    IAssetService                       assetService,
    IAssetMapper                        assetMapper)
    : IRequestHandler<GetAssetByIdRequest, AssetModel>
{
    public async Task<AssetModel> Handle(GetAssetByIdRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Fetching asset by ID {Id}", request.Id);

        var asset = await assetService.GetByIdAsync(request.Id);

        if (asset == null)
            throw new ResourceNotFoundException(nameof(asset), request.Id);

        return assetMapper.Map(asset);
    }
}

public class GetAssetByIdRequest(int id) : IRequest<AssetModel>
{
    public int Id { get; } = id;
}
