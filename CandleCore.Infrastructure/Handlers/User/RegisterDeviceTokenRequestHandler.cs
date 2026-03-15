using CandleCore.Interfaces.Repositories.DeviceToken;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.User;

public class RegisterDeviceTokenRequestHandler(
    ILogger<RegisterDeviceTokenRequestHandler> logger,
    IDeviceTokenRepository                     deviceTokenRepository)
    : IRequestHandler<RegisterDeviceTokenRequest>
{
    public async Task Handle(RegisterDeviceTokenRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Registering device token for user {UserId}", request.UserId);
        await deviceTokenRepository.UpsertAsync(request.UserId, request.Token);
    }
}

public class RegisterDeviceTokenRequest(int userId, string token) : IRequest
{
    public int    UserId { get; } = userId;
    public string Token  { get; } = token;
}
