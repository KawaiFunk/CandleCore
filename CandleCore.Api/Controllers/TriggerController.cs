using CandleCore.Api.Errors;
using CandleCore.Infrastructure.Handlers.Trigger;
using CandleCore.Models.Common;
using CandleCore.Models.Trigger;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace CandleCore.Api.Controllers;

[ApiController]
[Route("api/triggers")]
public class TriggerController(IMediator mediator) : ControllerBase
{
    [HttpGet("{userId:int}")]
    [ProducesResponseType(200, Type = typeof(List<TriggerModel>))]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> GetTriggersAsync(int userId)
    {
        try
        {
            var result = await mediator.Send(new GetTriggersRequest(userId));
            return Ok(result);
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }

    [HttpPost("{userId:int}")]
    [ProducesResponseType(201, Type = typeof(TriggerModel))]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> CreateTriggerAsync(int userId, [FromBody] CreateTriggerModel model)
    {
        try
        {
            var result = await mediator.Send(new CreateTriggerRequest(userId, model));
            return Created(string.Empty, result);
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }

    [HttpPatch("{userId:int}/{triggerId:int}")]
    [ProducesResponseType(200, Type = typeof(TriggerModel))]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> ToggleTriggerAsync(int userId, int triggerId)
    {
        try
        {
            var result = await mediator.Send(new ToggleTriggerRequest(userId, triggerId));
            return Ok(result);
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }

    [HttpDelete("{userId:int}/{triggerId:int}")]
    [ProducesResponseType(204)]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> DeleteTriggerAsync(int userId, int triggerId)
    {
        try
        {
            await mediator.Send(new DeleteTriggerRequest(userId, triggerId));
            return NoContent();
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }
}
