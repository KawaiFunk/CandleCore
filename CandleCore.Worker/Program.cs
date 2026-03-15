using CandleCore.Infrastructure.Extensions;
using CandleCore.Infrastructure.Persistence;
using CandleCore.Infrastructure.Persistence.MigrationService;
using CandleCore.Interfaces.Jobs;
using Hangfire;
using Microsoft.EntityFrameworkCore;
using Serilog;

var builder = Host.CreateApplicationBuilder(args);

builder.Configuration
    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
    .AddJsonFile($"appsettings.{builder.Environment.EnvironmentName}.json", optional: true, reloadOnChange: true)
    .AddEnvironmentVariables();

builder.Services.AddCandleCoreWorkerServices(builder.Configuration);

builder.Services.AddSerilog((context, configuration) =>
    configuration.ReadFrom.Configuration(builder.Configuration));

var host = builder.Build();

using (var scope = host.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<CandleCoreDbContext>();
    await db.Database.MigrateAsync();

    var migrationService = scope.ServiceProvider.GetRequiredService<MigrationService>();
    await migrationService.ApplyMigrationsAsync();

    var recurringJobs = scope.ServiceProvider.GetRequiredService<IRecurringJobManager>();
    recurringJobs.AddOrUpdate<IAssetSyncJob>(
        "SyncAssetsJob",
        job => job.SyncAssetsAsync(),
        Cron.Minutely);

    recurringJobs.AddOrUpdate<IAlarmCheckJob>(
        "CheckAlarmsJob",
        job => job.CheckAlarmsAsync(),
        Cron.Minutely);
}

await host.RunAsync();