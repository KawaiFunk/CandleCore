using CandleCore.Exceptions;
using CandleCore.Interfaces.Repositories.Favorite;
using CandleCore.Interfaces.Services.Asset;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.Favorite;

public class ToggleFavoriteRequestHandler(
    ILogger<ToggleFavoriteRequestHandler> logger,
    IFavoriteRepository                   favoriteRepository,
    IAssetService                         assetService)
    : IRequestHandler<ToggleFavoriteRequest, bool>
{
    public async Task<bool> Handle(ToggleFavoriteRequest request, CancellationToken cancellationToken)
    {
        var asset = await assetService.GetByIdAsync(request.AssetId);
        if (asset == null)
            throw new ResourceNotFoundException("Asset", request.AssetId);

        var exists = await favoriteRepository.ExistsAsync(request.UserId, request.AssetId);

        if (exists)
        {
            await favoriteRepository.RemoveAsync(request.UserId, request.AssetId);
            logger.LogInformation("Removed favorite asset {AssetId} for user {UserId}", request.AssetId, request.UserId);
            return false;
        }

        await favoriteRepository.AddAsync(request.UserId, request.AssetId);
        logger.LogInformation("Added favorite asset {AssetId} for user {UserId}", request.AssetId, request.UserId);
        return true;
    }
}

public class ToggleFavoriteRequest(int userId, int assetId) : IRequest<bool>
{
    public int UserId  { get; } = userId;
    public int AssetId { get; } = assetId;
}
