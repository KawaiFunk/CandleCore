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
    [ProducesResponseType(400)]
    public async Task<IActionResult> GetAllAsync([FromQuery] PagedListFilter filter)
    {
        try
        {
            var request  = new GetAllAssetsRequest(filter);
            var response = await mediator.Send(request);

            return Ok(response);
        }
        catch (Exception ex)
        {
            return BadRequest($"An error occurred: {ex.Message}");
        }
    }

    [HttpGet("{id:length(24)}")]
    [ProducesResponseType(200, Type = typeof(AssetModel))]
    [ProducesResponseType(404)]
    public async Task<IActionResult> GetByIdAsync(int id)
    {
        try
        {
            var request  = new GetAssetByIdRequest(id);
            var response = await mediator.Send(request);

            return Ok(response);
        }
        catch (Exception ex)
        {
            return BadRequest($"An error occurred: {ex.Message}");
        }
    }
}