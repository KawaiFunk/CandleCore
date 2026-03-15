using CandleCore.Domain.Entities.User;
using CandleCore.Infrastructure.Persistence.DbConstants;
using CandleCore.Infrastructure.Persistence.Helpers;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CandleCore.Infrastructure.Persistence.Configurations;

public class UserEntityTypeConfiguration : IEntityTypeConfiguration<UserEntity>
{
    public void Configure(EntityTypeBuilder<UserEntity> builder)
    {
        builder.HasAllPropertiesSnakeCase();

        builder.ToTable(DatabaseTables.Users, DatabaseSchemas.Users);

        builder.HasKey(u => u.Id);

        builder.Property(u => u.Username)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(u => u.Email)
            .IsRequired()
            .HasMaxLength(255);

        builder.Property(u => u.Password)
            .IsRequired()
            .HasMaxLength(512);

        builder.HasIndex(u => u.Username).IsUnique();
        builder.HasIndex(u => u.Email).IsUnique();

        builder.Property(u => u.CreatedAtUtc)
            .HasDefaultValueSql("NOW()")
            .ValueGeneratedOnAdd();

        builder.Property(u => u.UpdatedAtUtc)
            .HasDefaultValueSql("NOW()")
            .ValueGeneratedOnAddOrUpdate();
    }
}
