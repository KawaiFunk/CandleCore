using CandleCore.Interfaces.Services.User;
using CandleCore.Models.User;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.User;

public class RegisterUserRequestHandler(
    ILogger<RegisterUserRequestHandler> logger,
    IUserService                        userService)
    : IRequestHandler<RegisterUserRequest, UserModel>
{
    public async Task<UserModel> Handle(RegisterUserRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Registering user with username {Username}", request.Request.Username);

        var user = await userService.RegisterAsync(request.Request);

        logger.LogInformation("User {Username} registered successfully with ID {Id}", user.Username, user.Id);

        return user;
    }
}

public class RegisterUserRequest(RegisterRequest request) : IRequest<UserModel>
{
    public RegisterRequest Request { get; } = request;
}
