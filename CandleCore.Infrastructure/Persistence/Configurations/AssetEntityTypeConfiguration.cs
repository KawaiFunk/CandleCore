using CandleCore.Domain.Entities.Asset;
using CandleCore.Infrastructure.Helpers;
using CandleCore.Infrastructure.Persistence.DbConstants;
using CandleCore.Infrastructure.Persistence.Helpers;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CandleCore.Infrastructure.Persistence.Configurations
{
    public class AssetEntityTypeConfiguration : IEntityTypeConfiguration<AssetEntity>
    {
        public void Configure(EntityTypeBuilder<AssetEntity> builder)
        {
            builder.HasAllPropertiesSnakeCase();

            builder.ToTable(DatabaseTables.Assets, DatabaseSchemas.Assets);

            builder.HasKey(a => a.Id);

            builder.Property(a => a.ExternalId)
                .IsRequired()
                .HasMaxLength(50);

            builder.Property(a => a.Symbol)
                .IsRequired()
                .HasMaxLength(10);

            builder.Property(a => a.Name)
                .IsRequired()
                .HasMaxLength(100);

            builder.Property(a => a.Rank)
                .IsRequired();

            builder.Property(a => a.PriceUsd)
                .HasColumnType("decimal(18,8)");

            builder.Property(a => a.PriceBtc)
                .HasColumnType("decimal(18,8)");

            builder.Property(a => a.MarketCapUsd)
                .HasColumnType("decimal(18,2)");

            builder.Property(a => a.Volume24a)
                .HasColumnType("decimal(18,2)");

            builder.Property(a => a.PercentChange1h)
                .HasColumnType("decimal(18,4)");

            builder.Property(a => a.PercentChange24h)
                .HasColumnType("decimal(18,4)");

            builder.Property(a => a.PercentChange7d)
                .HasColumnType("decimal(18,4)");

            builder.HasIndex(a => a.ExternalId).IsUnique();
            builder.HasIndex(a => a.Symbol).IsUnique();

            builder.Property(a => a.CreatedAtUtc)
                .HasDefaultValueSql("NOW()")
                .ValueGeneratedOnAdd();

            builder.Property(a => a.UpdatedAtUtc)
                .HasDefaultValueSql("NOW()")
                .ValueGeneratedOnAddOrUpdate();
        }
    }
}