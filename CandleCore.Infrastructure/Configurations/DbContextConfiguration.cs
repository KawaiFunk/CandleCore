using CandleCore.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Configurations;

public static class DbContextConfiguration
{
    public static IServiceCollection AddDbContextConfiguration(this IServiceCollection services,
        string?                                                                        connectionString)
    {
        services.AddDbContext<CandleCoreDbContext>(options =>
            options.UseNpgsql(connectionString,
                b => b.MigrationsAssembly("CandleCore.Infrastructure")));

        return services;
    }
}