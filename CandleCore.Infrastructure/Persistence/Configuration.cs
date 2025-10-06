using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Persistence;

public static class Configuration
{
    public static IServiceCollection AddMigrationService(this IServiceCollection services, IConfiguration configuration)
    {
        var migrationsPath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "CandleCore.Infrastructure", "Persistence", "Migrations"));
        var connectionString = configuration.GetConnectionString("DefaultConnection");
        services.AddSingleton(new MigrationService.MigrationService(migrationsPath, connectionString));
        return services;
    }
}