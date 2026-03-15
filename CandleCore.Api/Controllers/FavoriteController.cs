using CandleCore.Api.Errors;
using CandleCore.Application.Models.Common;
using CandleCore.Infrastructure.Handlers.Favorite;
using CandleCore.Models.Asset;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace CandleCore.Api.Controllers;

[ApiController]
[Route("api/favorites")]
public class FavoriteController(IMediator mediator) : ControllerBase
{
    [HttpGet("{userId:int}")]
    [ProducesResponseType(200, Type = typeof(List<AssetModel>))]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> GetFavoritesAsync(int userId)
    {
        try
        {
            var result = await mediator.Send(new GetFavoritesRequest(userId));
            return Ok(result);
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }

    [HttpPost("{userId:int}/{assetId:int}")]
    [ProducesResponseType(200, Type = typeof(bool))]
    [ProducesResponseType(404, Type = typeof(ApiErrorModel))]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> ToggleFavoriteAsync(int userId, int assetId)
    {
        try
        {
            var isFavorite = await mediator.Send(new ToggleFavoriteRequest(userId, assetId));
            return Ok(new { isFavorite });
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }
}
