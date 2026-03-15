using CandleCore.Interfaces.Services.Note;
using CandleCore.Models.Note;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.Note;

public class CreateNoteRequestHandler(
    ILogger<CreateNoteRequestHandler> logger,
    INoteService                      noteService)
    : IRequestHandler<CreateNoteRequest, NoteModel>
{
    public async Task<NoteModel> Handle(CreateNoteRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Creating note for user {UserId}", request.UserId);
        return await noteService.CreateAsync(request.UserId, request.Model);
    }
}

public class CreateNoteRequest(int userId, CreateNoteModel model) : IRequest<NoteModel>
{
    public int             UserId { get; } = userId;
    public CreateNoteModel Model  { get; } = model;
}
