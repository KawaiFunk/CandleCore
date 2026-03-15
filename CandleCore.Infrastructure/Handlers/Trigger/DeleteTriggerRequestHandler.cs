using CandleCore.Interfaces.Services.Trigger;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.Trigger;

public class DeleteTriggerRequestHandler(
    ILogger<DeleteTriggerRequestHandler> logger,
    ITriggerService                      triggerService)
    : IRequestHandler<DeleteTriggerRequest>
{
    public async Task Handle(DeleteTriggerRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Deleting trigger {TriggerId} for user {UserId}", request.TriggerId, request.UserId);
        await triggerService.DeleteAsync(request.UserId, request.TriggerId);
    }
}

public class DeleteTriggerRequest(int userId, int triggerId) : IRequest
{
    public int UserId    { get; } = userId;
    public int TriggerId { get; } = triggerId;
}
