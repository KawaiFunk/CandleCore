using CandleCore.Infrastructure.Persistence;
using CandleCore.Infrastructure.Persistence.MigrationService;
using CandleCore.Interfaces.Jobs;
using Hangfire;
using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Extensions;

public static class ApplicationBuilderExtensions
{
    public static async Task UseCandleCoreStartupAsync(this IApplicationBuilder app)
    {
        using var scope = app.ApplicationServices.CreateScope();
        var       db    = scope.ServiceProvider.GetRequiredService<CandleCoreDbContext>();
        await db.Database.MigrateAsync();

        var recurringJobs = scope.ServiceProvider.GetRequiredService<IRecurringJobManager>();
        recurringJobs.AddOrUpdate<IAssetSyncJob>(
            "SyncAssetsJob",
            job => job.SyncAssetsAsync(),
            Cron.Minutely);

        var migrationService = scope.ServiceProvider.GetRequiredService<MigrationService>();
        await migrationService.ApplyMigrationsAsync();
    }
}