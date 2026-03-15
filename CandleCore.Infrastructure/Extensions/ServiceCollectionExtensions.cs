using CandleCore.Infrastructure.Behaviors;
using CandleCore.Infrastructure.Clients;
using CandleCore.Infrastructure.Configurations;
using CandleCore.Infrastructure.Handlers.Asset;
using CandleCore.Infrastructure.Mappers;
using CandleCore.Infrastructure.Options;
using CandleCore.Infrastructure.Persistence;
using CandleCore.Infrastructure.Persistence.Repositories;
using CandleCore.Infrastructure.Services;
using CandleCore.Infrastructure.Validators.Trigger;
using FluentValidation;
using Hangfire;
using Hangfire.PostgreSql;
using MediatR;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddCandleCoreServices(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddMigrationService(configuration);
        services.AddCustomOptions(configuration);
        services.AddServices();
        services.AddRepositories();
        services.AddMappers();
        services.AddClients();
        services.AddDbContextConfiguration(configuration.GetConnectionString("DefaultConnection"));
        services.AddControllers();
        services.AddEndpointsApiExplorer();
        services.AddValidatorsFromAssemblyContaining<CreateTriggerRequestValidator>();
        services.AddMediatR(cfg =>
        {
            cfg.RegisterServicesFromAssemblyContaining<GetAllAssetsRequestHandler>();
            cfg.AddOpenBehavior(typeof(ValidationPipelineBehavior<,>));
            cfg.AddOpenBehavior(typeof(ExceptionHandlingBehavior<,>));
        });
        services.AddHangfire(config =>
            config.UsePostgreSqlStorage(configuration.GetConnectionString("DefaultConnection")));
        return services;
    }
}