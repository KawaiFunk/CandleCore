using CandleCore.Domain.Entities.Trigger;
using CandleCore.Infrastructure.Persistence.DbConstants;
using CandleCore.Infrastructure.Persistence.Helpers;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CandleCore.Infrastructure.Persistence.Configurations;

public class TriggerEntityTypeConfiguration : IEntityTypeConfiguration<TriggerEntity>
{
    public void Configure(EntityTypeBuilder<TriggerEntity> builder)
    {
        builder.HasAllPropertiesSnakeCase();

        builder.ToTable(DatabaseTables.Triggers, DatabaseSchemas.Triggers);

        builder.HasKey(t => t.Id);

        builder.Property(t => t.UserId).IsRequired();

        builder.Property(t => t.AssetId).IsRequired();

        builder.Property(t => t.AssetName)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(t => t.Condition).IsRequired();

        builder.Property(t => t.TargetPrice)
            .IsRequired()
            .HasPrecision(18, 8);

        builder.Property(t => t.IsActive).IsRequired();

        builder.Property(t => t.TriggeredAt).IsRequired(false);

        builder.Property(t => t.CreatedAtUtc)
            .HasDefaultValueSql("NOW()")
            .ValueGeneratedOnAdd();

        builder.Property(t => t.UpdatedAtUtc)
            .HasDefaultValueSql("NOW()")
            .ValueGeneratedOnAddOrUpdate();

        builder.HasIndex(t => t.UserId);
        builder.HasIndex(t => t.AssetId);
        builder.HasIndex(t => t.IsActive);
    }
}
