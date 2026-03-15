using CandleCore.Domain.Entities.User;
using CandleCore.Infrastructure.Persistence.DbConstants;
using CandleCore.Infrastructure.Persistence.Helpers;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CandleCore.Infrastructure.Persistence.Configurations;

public class DeviceTokenEntityTypeConfiguration : IEntityTypeConfiguration<DeviceTokenEntity>
{
    public void Configure(EntityTypeBuilder<DeviceTokenEntity> builder)
    {
        builder.HasAllPropertiesSnakeCase();

        builder.ToTable(DatabaseTables.DeviceTokens, DatabaseSchemas.Users);

        builder.HasKey(d => d.Id);

        builder.Property(d => d.UserId).IsRequired();

        builder.Property(d => d.Token)
            .IsRequired()
            .HasMaxLength(512);

        builder.Property(d => d.CreatedAtUtc)
            .HasDefaultValueSql("NOW()")
            .ValueGeneratedOnAdd();

        builder.Property(d => d.UpdatedAtUtc)
            .HasDefaultValueSql("NOW()")
            .ValueGeneratedOnAddOrUpdate();

        builder.HasIndex(d => d.UserId).IsUnique();
    }
}
