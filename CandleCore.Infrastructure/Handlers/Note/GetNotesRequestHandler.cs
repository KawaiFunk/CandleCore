using CandleCore.Interfaces.Services.Note;
using CandleCore.Models.Note;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.Note;

public class GetNotesRequestHandler(
    ILogger<GetNotesRequestHandler> logger,
    INoteService                    noteService)
    : IRequestHandler<GetNotesRequest, List<NoteModel>>
{
    public async Task<List<NoteModel>> Handle(GetNotesRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Fetching notes for user {UserId}", request.UserId);
        return await noteService.GetByUserIdAsync(request.UserId);
    }
}

public class GetNotesRequest(int userId) : IRequest<List<NoteModel>>
{
    public int UserId { get; } = userId;
}
