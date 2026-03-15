using CandleCore.Interfaces.Services.Trigger;
using CandleCore.Models.Trigger;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.Trigger;

public class CreateTriggerRequestHandler(
    ILogger<CreateTriggerRequestHandler> logger,
    ITriggerService                      triggerService)
    : IRequestHandler<CreateTriggerRequest, TriggerModel>
{
    public async Task<TriggerModel> Handle(CreateTriggerRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Creating trigger for user {UserId}", request.UserId);
        return await triggerService.CreateAsync(request.UserId, request.Model);
    }
}

public class CreateTriggerRequest(int userId, CreateTriggerModel model) : IRequest<TriggerModel>
{
    public int                UserId { get; } = userId;
    public CreateTriggerModel Model  { get; } = model;
}
