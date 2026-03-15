using CandleCore.Interfaces.Services.Trigger;
using CandleCore.Models.Trigger;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.Trigger;

public class ToggleTriggerRequestHandler(
    ILogger<ToggleTriggerRequestHandler> logger,
    ITriggerService                      triggerService)
    : IRequestHandler<ToggleTriggerRequest, TriggerModel>
{
    public async Task<TriggerModel> Handle(ToggleTriggerRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Toggling trigger {TriggerId} for user {UserId}", request.TriggerId, request.UserId);
        return await triggerService.ToggleActiveAsync(request.UserId, request.TriggerId);
    }
}

public class ToggleTriggerRequest(int userId, int triggerId) : IRequest<TriggerModel>
{
    public int UserId    { get; } = userId;
    public int TriggerId { get; } = triggerId;
}
