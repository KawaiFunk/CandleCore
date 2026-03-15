using CandleCore.Interfaces.Services.User;
using CandleCore.Models.User;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Handlers.User;

public class LoginUserRequestHandler(
    ILogger<LoginUserRequestHandler> logger,
    IUserService                     userService)
    : IRequestHandler<LoginUserRequest, UserModel?>
{
    public async Task<UserModel?> Handle(LoginUserRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Login attempt for username {Username}", request.Request.Username);

        var user = await userService.LoginAsync(request.Request);

        if (user == null)
            logger.LogWarning("Failed login attempt for username {Username}", request.Request.Username);
        else
            logger.LogInformation("User {Username} logged in successfully", user.Username);

        return user;
    }
}

public class LoginUserRequest(LoginRequest request) : IRequest<UserModel?>
{
    public LoginRequest Request { get; } = request;
}
