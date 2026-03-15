using CandleCore.Api.Errors;
using CandleCore.Application.Models.Common;
using CandleCore.Domain.Common.PagedList;
using CandleCore.Infrastructure.Handlers.Asset;
using CandleCore.Models.Asset;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace CandleCore.Api.Controllers;

[ApiController]
[Route("api/assets")]
public class AssetController(IMediator mediator) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(200, Type = typeof(IPagedList<AssetModel>))]
    [ProducesResponseType(400, Type = typeof(ApiErrorModel))]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> GetAllAsync([FromQuery] AssetFilter filter)
    {
        try
        {
            var result = await mediator.Send(new GetAllAssetsRequest(filter));
            return Ok(result);
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }

    [HttpGet("{id:int}")]
    [ProducesResponseType(200, Type = typeof(DetailedAssetModel))]
    [ProducesResponseType(404, Type = typeof(ApiErrorModel))]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> GetByIdAsync(int id)
    {
        try
        {
            var result = await mediator.Send(new GetAssetByIdRequest(id));
            return Ok(result);
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }
}
