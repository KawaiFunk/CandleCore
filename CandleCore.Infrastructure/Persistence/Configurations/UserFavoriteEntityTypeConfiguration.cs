using CandleCore.Domain.Entities.Favorite;
using CandleCore.Infrastructure.Persistence.DbConstants;
using CandleCore.Infrastructure.Persistence.Helpers;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CandleCore.Infrastructure.Persistence.Configurations;

public class UserFavoriteEntityTypeConfiguration : IEntityTypeConfiguration<UserFavoriteEntity>
{
    public void Configure(EntityTypeBuilder<UserFavoriteEntity> builder)
    {
        builder.HasAllPropertiesSnakeCase();

        builder.ToTable(DatabaseTables.UserFavorites, DatabaseSchemas.Favorites);

        builder.HasKey(f => new { f.UserId, f.AssetId });

        builder.Property(f => f.UserId).IsRequired();
        builder.Property(f => f.AssetId).IsRequired();
    }
}
