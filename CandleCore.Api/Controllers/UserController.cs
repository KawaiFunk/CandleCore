using CandleCore.Api.Errors;
using CandleCore.Infrastructure.Handlers.User;
using CandleCore.Models.Common;
using CandleCore.Models.User;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace CandleCore.Api.Controllers;

[ApiController]
[Route("api/users")]
public class UserController(IMediator mediator) : ControllerBase
{
    [HttpPost("register")]
    [ProducesResponseType(201, Type = typeof(UserModel))]
    [ProducesResponseType(409, Type = typeof(ApiErrorModel))]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> RegisterAsync([FromBody] RegisterRequest request)
    {
        try
        {
            var user = await mediator.Send(new RegisterUserRequest(request));
            return Created($"api/users/{user.Id}", user);
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }

    [HttpPost("login")]
    [ProducesResponseType(200, Type = typeof(UserModel))]
    [ProducesResponseType(401, Type = typeof(ApiErrorModel))]
    [ProducesResponseType(500, Type = typeof(ApiErrorModel))]
    public async Task<IActionResult> LoginAsync([FromBody] LoginRequest request)
    {
        try
        {
            var user = await mediator.Send(new LoginUserRequest(request));
            return Ok(user);
        }
        catch (Exception ex)
        {
            return ApiErrorBuilder.FromException(ex);
        }
    }
}
