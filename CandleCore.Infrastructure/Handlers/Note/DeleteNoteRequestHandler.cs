using CandleCore.Interfaces.Services.Note;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.Note;

public class DeleteNoteRequestHandler(
    ILogger<DeleteNoteRequestHandler> logger,
    INoteService                      noteService)
    : IRequestHandler<DeleteNoteRequest>
{
    public async Task Handle(DeleteNoteRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Deleting note {NoteId} for user {UserId}", request.NoteId, request.UserId);
        await noteService.DeleteAsync(request.UserId, request.NoteId);
    }
}

public class DeleteNoteRequest(int userId, int noteId) : IRequest
{
    public int UserId { get; } = userId;
    public int NoteId { get; } = noteId;
}
