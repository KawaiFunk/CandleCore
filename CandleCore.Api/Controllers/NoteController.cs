using CandleCore.Api.Errors;
using CandleCore.Application.Models.Common;
using CandleCore.Infrastructure.Handlers.Note;
using CandleCore.Models.Note;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace CandleCore.Api.Controllers;

[ApiController]
[Route("api/notes")]
public class NoteController(IMediator mediator) : ControllerBase
{
    [HttpGet("{userId:int}")]
    [ProducesResponseType(200, Type = typeof(List<NoteModel>))]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> GetNotesAsync(int userId)
    {
        try
        {
            var result = await mediator.Send(new GetNotesRequest(userId));
            return Ok(result);
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }

    [HttpPost("{userId:int}")]
    [ProducesResponseType(201, Type = typeof(NoteModel))]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> CreateNoteAsync(int userId, [FromBody] CreateNoteModel model)
    {
        try
        {
            var result = await mediator.Send(new CreateNoteRequest(userId, model));
            return Created(string.Empty, result);
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }

    [HttpDelete("{userId:int}/{noteId:int}")]
    [ProducesResponseType(204)]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> DeleteNoteAsync(int userId, int noteId)
    {
        try
        {
            await mediator.Send(new DeleteNoteRequest(userId, noteId));
            return NoContent();
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }
}
