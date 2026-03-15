using CandleCore.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CandleCore.Infrastructure.Behaviors;

public class ExceptionHandlingBehavior<TRequest, TResponse>(
    ILogger<ExceptionHandlingBehavior<TRequest, TResponse>> logger)
    : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
{
    public async Task<TResponse> Handle(
        TRequest                          request,
        RequestHandlerDelegate<TResponse> next,
        CancellationToken                 cancellationToken)
    {
        try
        {
            return await next();
        }
        catch (AppException ex)
        {
            logger.LogWarning(
                "Application exception [{ErrorCode}] for request {RequestType}: {Message}",
                ex.ErrorCode, typeof(TRequest).Name, ex.Message);
            throw;
        }
        catch (Exception ex)
        {
            logger.LogError(
                ex,
                "Unhandled exception for request {RequestType}",
                typeof(TRequest).Name);
            throw;
        }
    }
}
