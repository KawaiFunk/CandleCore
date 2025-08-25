using Microsoft.EntityFrameworkCore;

namespace CandleCore.Infrastructure.Persistence;

public class CandleCoreDbContext(DbContextOptions<CandleCoreDbContext> options) : DbContext(options)
{
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(CandleCoreDbContext).Assembly);
        base.OnModelCreating(modelBuilder);
    }
}