using CandleCore.Interfaces.Services.Favorite;
using CandleCore.Models.Asset;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.Favorite;

public class GetFavoritesRequestHandler(
    ILogger<GetFavoritesRequestHandler> logger,
    IFavoriteService                    favoriteService)
    : IRequestHandler<GetFavoritesRequest, List<AssetModel>>
{
    public async Task<List<AssetModel>> Handle(GetFavoritesRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Fetching favorites for user {UserId}", request.UserId);
        return await favoriteService.GetFavoritesAsync(request.UserId);
    }
}

public class GetFavoritesRequest(int userId) : IRequest<List<AssetModel>>
{
    public int UserId { get; } = userId;
}
