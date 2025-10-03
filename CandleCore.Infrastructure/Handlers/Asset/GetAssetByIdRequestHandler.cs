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
        try
        {
            logger.LogInformation("Fetching asset by ID: {Id}", request.Id);
            var asset = await assetService.GetByIdAsync(request.Id);

            if (asset == null)
            {
                logger.LogWarning("Asset with ID {Id} not found", request.Id);
                throw new KeyNotFoundException($"Asset with ID {request.Id} not found.");
            }

            return assetMapper.Map(asset);
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }
}

public class GetAssetByIdRequest(int id) : IRequest<AssetModel>
{
    public int Id { get; set; } = id;
}