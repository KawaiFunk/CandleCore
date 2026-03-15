using CandleCore.Exceptions;
using CandleCore.Models.Common;
using Microsoft.AspNetCore.Mvc;

namespace CandleCore.Api.Errors;

public static class ApiErrorBuilder
{
    public static IActionResult FromException(Exception ex) => ex switch
    {
        InvalidCredentialsException e => Unauthorized(e),
        ResourceNotFoundException   e => NotFound(e),
        DuplicateResourceException  e => Conflict(e),
        AppException                e => BadRequest(e),
        _                             => InternalError(ex),
    };

    private static ObjectResult Unauthorized(AppException ex) => new ObjectResult(Error(ex)) { StatusCode = StatusCodes.Status401Unauthorized };

    private static ObjectResult NotFound(AppException ex) =>
        new(Error(ex)) { StatusCode = StatusCodes.Status404NotFound };

    private static ObjectResult Conflict(AppException ex) =>
        new(Error(ex)) { StatusCode = StatusCodes.Status409Conflict };

    private static ObjectResult BadRequest(AppException ex) =>
        new(Error(ex)) { StatusCode = StatusCodes.Status400BadRequest };

    private static ObjectResult InternalError(Exception ex) =>
        new(new ApiErrorModel
        {
            ErrorCode = ErrorCodes.InternalError,
            Message   = "An unexpected error occurred.",
        }) { StatusCode = StatusCodes.Status500InternalServerError };

    private static ApiErrorModel Error(AppException ex) => new()
    {
        ErrorCode = ex.ErrorCode,
        Message   = ex.Message,
    };
}
