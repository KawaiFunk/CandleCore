using CandleCore.Exceptions;
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
    : IRequestHandler<GetAssetByIdRequest, DetailedAssetModel>
{
    public async Task<DetailedAssetModel> Handle(GetAssetByIdRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Fetching asset by ID {Id}", request.Id);

        var asset = await assetService.GetByIdAsync(request.Id);

        if (asset == null)
            throw new ResourceNotFoundException(nameof(asset), request.Id);

        return assetMapper.MapDetailed(asset);
    }
}

public class GetAssetByIdRequest(int id) : IRequest<DetailedAssetModel>
{
    public int Id { get; } = id;
}
