using CandleCore.Infrastructure.Handlers.User;
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
    [ProducesResponseType(400)]
    public async Task<IActionResult> RegisterAsync([FromBody] RegisterRequest request)
    {
        try
        {
            var user = await mediator.Send(new RegisterUserRequest(request));
            return Created($"api/users/{user.Id}", user);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpPost("login")]
    [ProducesResponseType(200, Type = typeof(UserModel))]
    [ProducesResponseType(401)]
    public async Task<IActionResult> LoginAsync([FromBody] LoginRequest request)
    {
        var user = await mediator.Send(new LoginUserRequest(request));

        if (user == null)
            return Unauthorized("Invalid username or password.");

        return Ok(user);
    }
}
