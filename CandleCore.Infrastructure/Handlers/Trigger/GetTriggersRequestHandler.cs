using CandleCore.Interfaces.Services.Trigger;
using CandleCore.Models.Trigger;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.Trigger;

public class GetTriggersRequestHandler(
    ILogger<GetTriggersRequestHandler> logger,
    ITriggerService                    triggerService)
    : IRequestHandler<GetTriggersRequest, List<TriggerModel>>
{
    public async Task<List<TriggerModel>> Handle(GetTriggersRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Fetching triggers for user {UserId}", request.UserId);
        return await triggerService.GetByUserIdAsync(request.UserId);
    }
}

public class GetTriggersRequest(int userId) : IRequest<List<TriggerModel>>
{
    public int UserId { get; } = userId;
}
