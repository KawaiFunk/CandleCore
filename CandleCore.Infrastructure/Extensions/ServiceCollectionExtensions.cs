using CandleCore.Infrastructure.Clients;
using CandleCore.Infrastructure.Configurations;
using CandleCore.Infrastructure.Handlers.Asset;
using CandleCore.Infrastructure.Jobs;
using CandleCore.Infrastructure.Mappers;
using CandleCore.Infrastructure.Options;
using CandleCore.Infrastructure.Persistence;
using CandleCore.Infrastructure.Persistence.Repositories;
using CandleCore.Infrastructure.Services;
using Hangfire;
using Hangfire.PostgreSql;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddCandleCoreServices(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddMigrationService(configuration);
        services.AddCustomOptions(configuration);
        services.AddJobs();
        services.AddServices();
        services.AddRepositories();
        services.AddMappers();
        services.AddClients();
        services.AddDbContextConfiguration(configuration.GetConnectionString("DefaultConnection"));
        services.AddControllers();
        services.AddEndpointsApiExplorer();
        services.AddMediatR(cfg =>
            cfg.RegisterServicesFromAssemblyContaining<GetAllAssetsRequestHandler>());
        services.AddHangfire(config =>
            config.UsePostgreSqlStorage(configuration.GetConnectionString("DefaultConnection")));
        services.AddHangfireServer();
        return services;
    }
}